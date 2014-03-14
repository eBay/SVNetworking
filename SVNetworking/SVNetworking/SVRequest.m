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
    
    // Connection ivars (iOS 7)
    NSURLSessionTask *_sessionTask;
    
    // body data
    NSMutableDictionary* _values;
}

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

#pragma mark - Sending
-(void)start
{
#if TARGET_OS_IPHONE
    [self.class showNetworkActivityIndicator];
#endif
    
    if (NSClassFromString(@"NSURLSession"))
    {
        _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:[self constructRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
        }];
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
        
        #if TARGET_OS_IPHONE
        [self.class hideNetworkActivityIndicator];
        #endif
    }
    else if (_sessionTask)
    {
        [_sessionTask cancel];
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
    // retain self temporarily
    if (_delegate) CFRetain((__bridge CFTypeRef)_delegate);
    
    [self handleCompletionWithData:_data response:_response];
    _connection = nil;
    
#if TARGET_OS_IPHONE
    [self.class hideNetworkActivityIndicator];
#endif
    if (_delegate) CFRelease((__bridge CFTypeRef)_delegate);
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [_delegate request:self failedWithError:error];
    _connection = nil;
    
#if TARGET_OS_IPHONE
    [self.class hideNetworkActivityIndicator];
#endif
}

#pragma mark - Subclass Implementation
-(NSMutableURLRequest*)constructRequest
{
    NSURL* requestURL = _URL;
    
    if (_values && _method == SVRequestMethodGET)
    {
        NSArray* pairs = SVMap(_values.allKeys, ^id(NSString* key) {
            return [NSString stringWithFormat:@"%@=%@", key, SVURLEncode(SVStringify([_values objectForKey:key]))];
        });
        
        NSString* queryString = [@"?" stringByAppendingString:[pairs componentsJoinedByString:@"&"]];
        requestURL = [NSURL URLWithString:queryString relativeToURL:requestURL];
    }
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    request.HTTPMethod = SVStringForRequestMethod(_method);
    
    if (_bodyData)
    {
#if TARGET_OS_IPHONE
        NSString* length = [NSString stringWithFormat:@"%lu", (long)_bodyData.length];
#else
        NSString* length = [NSString stringWithFormat:@"%lu", _bodyData.length];
#endif
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:_bodyData];
    }
    else if (_values && _method != SVRequestMethodGET)
    {
        NSArray* pairs = SVMap(_values.allKeys, ^id(NSString* key) {
            return [NSString stringWithFormat:@"%@=%@", key, SVURLEncode(SVStringify([_values objectForKey:key]))];
        });
        
        NSString* bodyString = [pairs componentsJoinedByString:@"&"];
        NSData* body = [bodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
#if TARGET_OS_IPHONE
        NSString* length = [NSString stringWithFormat:@"%lu", (long)body.length];
#else
        NSString* length = [NSString stringWithFormat:@"%lu", body.length];
#endif
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
    }
    
    if (_contentType)
    {
        [request setValue:_contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}

-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
    [self doesNotRecognizeSelector:_cmd];
}

#if TARGET_OS_IPHONE
#pragma mark - Spinner
static NSInteger spinnerCount = 0;
+(void)showNetworkActivityIndicator
{
    if (spinnerCount == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    spinnerCount++;
}

+(void)hideNetworkActivityIndicator
{
    spinnerCount--;
    
    if (spinnerCount == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
#endif

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
