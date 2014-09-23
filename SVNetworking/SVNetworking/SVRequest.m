/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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

NSString* SVURLEncode(NSString* string)
{
    return (__bridge_transfer id)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                         (__bridge CFStringRef)string,
                                                                         NULL,
                                                                         CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                         kCFStringEncodingUTF8);
}

@interface SVRequest ()
{
    // content length
    long long _expectedContentLength;
    long long _currentContentLength;
    
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
    if (!_values)
    {
        _values = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if (value)
    {
        _values[key] = value;
    }
    else
    {
        [_values removeObjectForKey:key];
    }
}

#pragma mark - HTTP Headers
-(void)setValue:(id)value forHTTPHeaderField:(id<NSCopying>)HTTPHeaderField
{
    if (!_headers)
    {
        _headers = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    if (value)
    {
        _headers[HTTPHeaderField] = value;
    }
    else
    {
        [_headers removeObjectForKey:HTTPHeaderField];
    }
}

-(id)valueForHTTPHeaderField:(id<NSCopying>)HTTPHeaderField
{
    return _headers[HTTPHeaderField];
}

#pragma mark - Sending
-(void)start
{
    [[self.class networkActivityIndicatorDelegate] increaseNetworkActivityIndicatorCount];
    
    NSURLRequest *request = [self constructRequest];
    
    __weak SVRequest *weakSelf = self;
    
    _sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                [weakSelf.delegate request:self finishedWithResponse:response data:data];
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

-(void)cancel
{
    if (_sessionTask)
    {
        [_sessionTask cancel];
        _sessionTask = nil;
        
        [[self.class networkActivityIndicatorDelegate] decreaseNetworkActivityIndicatorCount];
    }
}

#pragma mark - Subclass Implementation
-(NSMutableURLRequest*)constructRequest
{
    NSURL* requestURL = _URL;
    NSString *parameterString = [self constructParameterString];
    
    // adjust GET URLs to include query string
    if (parameterString.length > 0 && _method == SVRequestMethodGET)
    {
        NSString* queryString = [@"?" stringByAppendingString:parameterString];
        requestURL = [NSURL URLWithString:queryString relativeToURL:requestURL];
    }
    
    // create request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    request.HTTPMethod = SVStringForRequestMethod(_method);
    
    // explicit body data
    if (_bodyData)
    {
        NSString* length = [NSString stringWithFormat:@"%lu", (unsigned long)_bodyData.length];
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:_bodyData];
    }
    else if (_values && _method != SVRequestMethodGET) // parameter-based body data for non-GET requests
    {
        NSData* body = [parameterString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        
        NSString* length = [NSString stringWithFormat:@"%lu", (unsigned long)body.length];
        
        [request setValue:length forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:body];
    }
    
    // add headers to the request
    [_headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:SVStringify(obj) forHTTPHeaderField:key];
    }];
    
    return request;
}

-(NSArray*)constructParameterPairs
{
    return SVMap(_values.allKeys, ^id(NSString* key) {
        return [NSString stringWithFormat:@"%@=%@", key, SVURLEncode(SVStringify([self->_values objectForKey:key]))];
    });
}

-(NSString*)constructParameterString
{
    NSArray* pairs = [self constructParameterPairs];
    return [pairs componentsJoinedByString:@"&"];
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

SVRequestMethod SVRequestMethodForString(NSString *string)
{
    if ([string isEqualToString:@"GET"])
    {
        return SVRequestMethodGET;
    }
    else if ([string isEqualToString:@"POST"])
    {
        return SVRequestMethodPOST;
    }
    else if ([string isEqualToString:@"DELETE"])
    {
        return SVRequestMethodDELETE;
    }
    else if ([string isEqualToString:@"PUT"])
    {
        return SVRequestMethodPUT;
    }
    
    return SVRequestMethodGET;
}
