#import <UIKit/UIKit.h>

#import "SVFunctional.h"
#import "SVRequest.h"

static NSString* SVStringify(id object)
{
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }
    
    if ([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    
    return [object description];
}

static NSString* SVURLEncode(NSString* string)
{
    return (__bridge_transfer id)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                         (__bridge CFStringRef)string,
                                                                         NULL,
                                                                         CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                         kCFStringEncodingUTF8);
}

@interface SVRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    // content length
    long long _expectedContentLength;
    long long _currentContentLength;
    
    // Connection ivars (iOS 6)
    NSMutableData* _data;
    NSURLConnection* _connection;
    NSHTTPURLResponse* _response;
    
    // body data
    NSMutableDictionary* _values;
    
    // headers
    NSMutableDictionary* _headers;
}

@property (nonatomic, strong) NSURLSessionTask *sessionTask;

@end

@implementation SVRequest

#pragma mark - Construction
+(instancetype)requestWithURL:(NSURL*)URL method:(SVRequestMethod)method
{
    SVRequest* request = [[self alloc] init];
    
    if (request)
    {
        request->_URL = URL;
        request->_method = method;
    }
    
    return request;
}

#pragma mark - Construction - GET
+(instancetype)GETRequestWithURL:(NSURL*)URL
{
    return [self requestWithURL:URL method:SVRequestMethodGET];
}

#pragma mark - Construction - POST
+(instancetype)POSTRequestWithURL:(NSURL*)URL
{
    return [self requestWithURL:URL method:SVRequestMethodPOST];
}

#pragma mark - Construction - PUT
+(instancetype)PUTRequestWithURL:(NSURL*)URL
{
    return [self requestWithURL:URL method:SVRequestMethodPUT];
}

#pragma mark - Construction - DELETE
+(instancetype)DELETERequestWithURL:(NSURL*)URL
{
    return [self requestWithURL:URL method:SVRequestMethodDELETE];
}

#pragma mark - Cleanup
-(void)dealloc
{
    [self cancel];
}

#pragma mark - Keyed Data
-(id)objectForKeyedSubscript:(id)key
{
    return [_values objectForKey:key];
}

-(void)setObject:(id)value forKeyedSubscript:(id<NSCopying>)key
{
    if (!_values) _values = [[NSMutableDictionary alloc] initWithCapacity:1];
    [_values setObject:value forKeyedSubscript:key];
}

#pragma mark - HTTP Headers
-(void)setValue:(id)value forHTTPHeaderField:(id<NSCopying>)HTTPHeaderField
{
    if (!_headers)
    {
        _headers = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    _headers[HTTPHeaderField] = value;
}

-(id)valueForHTTPHeaderField:(id<NSCopying>)HTTPHeaderField
{
    return _headers[HTTPHeaderField];
}

#pragma mark - Sending
-(void)start
{
    [[self.class networkActivityIndicatorDelegate] increaseNetworkActivityIndicatorCount];
    
    if ([NSURLSession class])
    {
        NSURLRequest *request = [self constructRequest];
        
        __weak SVRequest *weakSelf = self;
        
        _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data)
                {
                    [weakSelf handleCompletionWithData:data response:(NSHTTPURLResponse*)response];
                }
                else
                {
                    [weakSelf.delegate request:self failedWithError:error];
                }
                
                weakSelf.sessionTask = nil;
                
                [[weakSelf.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
            });
        }];
        
        [_sessionTask resume];
    }
    else
    {
        _data = [[NSMutableData alloc] init];
        _connection = [[NSURLConnection alloc] initWithRequest:self.constructRequest delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
    }
}

-(void)cancel
{
    if (_connection)
    {
        [_connection cancel];
        _connection = nil;
        _data = nil;
        
        [[self.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
    }
    else if (_sessionTask)
    {
        [_sessionTask cancel];
        _sessionTask = nil;
        
        [[self.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
    }
}

#pragma mark - URL Connection Delegate
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)resp
{
    _response = (id)resp;
    _expectedContentLength = _response.expectedContentLength;
    
    if ([_delegate respondsToSelector:@selector(request:receivedResponse:willUpdateProgress:)])
    {
        [_delegate request:self receivedResponse:resp willUpdateProgress:_expectedContentLength != NSURLResponseUnknownLength];
    }
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)respData
{
    _currentContentLength += respData.length;
    
    if (_expectedContentLength != NSURLResponseUnknownLength &&
        [_delegate respondsToSelector:@selector(request:updatedDownloadProgress:)])
    {
        double progress = ((double)MIN(_expectedContentLength, _currentContentLength)) / (double)_expectedContentLength;
        [_delegate request:self updatedDownloadProgress:progress];
    }
    
    [_data appendData:respData];
}

-(void)connection:(NSURLConnection *)connection
  didSendBodyData:(NSInteger)bytesWritten
totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if ([_delegate respondsToSelector:@selector(request:updatedUploadProgress:)])
    {
        double progress = ((double)totalBytesWritten) / ((double)totalBytesExpectedToWrite);
        [_delegate request:self updatedUploadProgress:progress];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [self handleCompletionWithData:_data response:_response];
    _connection = nil;
    
    [[self.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [_delegate request:self failedWithError:error];
    _connection = nil;
    
    [[self.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
}

#pragma mark - Subclass Implementation
-(NSMutableURLRequest*)constructRequest
{
    NSURL* requestURL = _URL;
    
    if (_values && _method == SVRequestMethodGET)
    {
        NSArray* pairs = SVMap(_values.allKeys, ^id(NSString* key) {
            return [NSString stringWithFormat:@"%@=%@", key, SVURLEncode(SVStringify([self->_values objectForKey:key]))];
        });
        
        NSString* queryString = [@"?" stringByAppendingString:[pairs componentsJoinedByString:@"&"]];
        requestURL = [NSURL URLWithString:queryString relativeToURL:requestURL];
    }
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    request.HTTPMethod = SVStringForRequestMethod(_method);
    
    if (_bodyData)
    {
        NSString* length = [NSString stringWithFormat:@"%lu", (unsigned long)_bodyData.length];
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:_bodyData];
    }
    else if (_values && _method != SVRequestMethodGET)
    {
        NSArray* pairs = SVMap(_values.allKeys, ^id(NSString* key) {
            return [NSString stringWithFormat:@"%@=%@", key, SVURLEncode(SVStringify([self->_values objectForKey:key]))];
        });
        
        NSString* bodyString = [pairs componentsJoinedByString:@"&"];
        NSData* body = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        NSString* length = [NSString stringWithFormat:@"%lu", (unsigned long)body.length];
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
    }
    
    
    [_headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:SVStringify(obj) forHTTPHeaderField:key];
    }];
    
    return request;
}

-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Network Activity Indicator Delegate
static id<SVRequestNetworkActivityIndicatorDelegate> SVRequestRequestNetworkActivityIndicatorDelegate = nil;

+(id<SVRequestNetworkActivityIndicatorDelegate>)networkActivityIndicatorDelegate
{
    return SVRequestRequestNetworkActivityIndicatorDelegate;
}

+(void)setNetworkActivityIndicatorDelegate:(id<SVRequestNetworkActivityIndicatorDelegate>)delegate
{
    SVRequestRequestNetworkActivityIndicatorDelegate = delegate;
}

@end

NSString* SVStringForRequestMethod(SVRequestMethod method)
{
    switch (method)
    {
        case SVRequestMethodGET:
            return @"GET";
        case SVRequestMethodPOST:
            return @"POST";
        case SVRequestMethodDELETE:
            return @"DELETE";
        case SVRequestMethodPUT:
            return @"PUT";
    }
}
