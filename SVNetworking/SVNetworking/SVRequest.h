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

#import <TargetConditionals.h>

/**
 Specifies HTTP methods as an enumeration.
 */
typedef NS_ENUM(NSInteger, SVRequestMethod)
{
    /**
     `GET`
     */
    SVRequestMethodGET,
    
    /**
     `POST`
     */
    SVRequestMethodPOST,
    
    /**
     `PUT`
     */
    SVRequestMethodPUT,
    
    /**
     `DELETE`
     */
    SVRequestMethodDELETE
};

/**
 A protocol for an object that keeps track of the current number of active request objects.
 */
@protocol SVRequestNetworkActivityIndicatorDelegate <NSObject>

/**
 Sent when the number of active requests increases.
 */
-(void)increaseNetworkActivityIndicatorCount;

/**
 Sent when the number of active requests decreases.
 */
-(void)decreaseNetworkActivityIndicatorCount;

@end

/**
 Converts a request method enumeration to a HTTP method string.
 
 @param method The request method to convert.
 */
FOUNDATION_EXTERN NSString* SVStringForRequestMethod(SVRequestMethod method);

/**
 Converts an HTTP method string to a request method enumeration.
 
 @param string The string to convert.
 */
FOUNDATION_EXTERN SVRequestMethod SVRequestMethodForString(NSString *string);

/**
 URL-encodes a string.
 
 @param string The string to URL encode.
 */
FOUNDATION_EXTERN NSString* SVURLEncode(NSString* string);

@class SVRequest;

/**
 Contains the delegate messages of an SVRequest object.
 */
@protocol SVRequestDelegate <NSObject>

@required
/** @name Required */

/**
 Indicates that the request has failed.
 
 @param request The request.
 @param error The error that caused the request to fail.
 */
-(void)request:(SVRequest*)request failedWithError:(NSError*)error;

@optional
/** @name Optional */

/**
 Indicates that the request has received a response.
 
 @param request The request.
 @param response The received response.
 @param willUpdateProgress `YES` if the request will provide determinate download progress, otherwise `NO`.
 */
-(void)request:(SVRequest*)request receivedResponse:(NSURLResponse*)response willUpdateProgress:(BOOL)willUpdateProgress;

/**
 Indicates that the request has updated its upload progress.
 
 @param request The request.
 @param progress The upload progress, a `double` between `0` and `1`.
 */
-(void)request:(SVRequest*)request updatedUploadProgress:(double)progress;

/**
 Indicates that the request has updated its download progress.
 
 This message may or may not be sent per-request, see -request:receivedResponse:willUpdateProgress:.
 
 @param request The request.
 @param progress The download progress, a `double` between `0` and `1`.
 */
-(void)request:(SVRequest*)request updatedDownloadProgress:(double)progress;

@end

/**
 An abstract base class for network requests.
 */
@interface SVRequest : NSObject

#pragma mark - Body Data
/** @name Body Data */

/**
 Body data for the request.
 
 If set, this data will override any parameters added to the request. If `nil`, the parameters will be used to create
 an HTTP body for non-`GET` requests.
 */
@property (readwrite, strong) NSData* bodyData;

#pragma mark - Keyed Data
/** @name Keyed Data */

/**
 Returns the value of a parameter for the request.
 
 @param key The parameter to return a value for.
 */
-(id)objectForKeyedSubscript:(id)key;

/**
 Sets the value of a parameter for the request.
 
 This value will be included in the query string or HTTP body, depending on which is appropriate for the request's
 -method.
 
 @param value The value for the parameter.
 @param key The parameter name.
 */
-(void)setObject:(id)value forKeyedSubscript:(id<NSCopying>)key;

#pragma mark - HTTP Headers
/** @name HTTP Headers */

/**
 Sets an HTTP header field.
 
 @param value The value to set for the field.
 @param HTTPHeaderField The header field to set.
 */
-(void)setValue:(id)value forHTTPHeaderField:(id<NSCopying>)HTTPHeaderField;

/**
 Returns the value currently set for the specified header field.
 
 @param HTTPHeaderField The header field to return the value of.
 */
-(id)valueForHTTPHeaderField:(id<NSCopying>)HTTPHeaderField;

#pragma mark - Delegation
/** @name Delegation */

/**
 The delegate for the request.
 */
@property (readwrite, weak) id<SVRequestDelegate> delegate;

#pragma mark - URL and Method
/** @name URL and HTTP method */

/**
 The base URL for the request. Immutable, and set upon construction.
 
 The full URL will depend on the parameters set for the request. Parameters should be set directly, instead of being
 passed as part of the URL.
 */
@property (readonly, strong) NSURL* URL;

/**
 The HTTP method for the request. Immutable, and set upon construction.
 */
@property (readonly) SVRequestMethod method;

#pragma mark - Construction
/** @name Construction */

/**
 Creates a request with the specified URL and HTTP method.
 
 All other construction messages call this message, so subclasses that want to add custom behavior to all requests only
 need to override this message.
 
 @param URL The URL for the request.
 @param method The HTTP method for the request.
 @returns A newly created request, with the specified URL and HTTP method.
 */
+(instancetype)requestWithURL:(NSURL*)URL method:(SVRequestMethod)method;

/**
 Creates a GET request with the specified URL.
 
 @param URL The URL for the request.
 @returns A newly created GET request, with the specified URL.
 */
+(instancetype)GETRequestWithURL:(NSURL*)URL;

/**
 Creates a POST request with the specified URL.
 
 @param URL The URL for the request.
 @returns A newly created POST request, with the specified URL.
 */
+(instancetype)POSTRequestWithURL:(NSURL*)URL;

/**
 Creates a PUT request with the specified URL.
 
 @param URL The URL for the request.
 @returns A newly created PUT request, with the specified URL.
 */
+(instancetype)PUTRequestWithURL:(NSURL*)URL;

/**
 Creates a DELETE request with the specified URL.
 
 @param URL The URL for the request.
 @returns A newly created DELETE request, with the specified URL.
 */
+(instancetype)DELETERequestWithURL:(NSURL*)URL;

#pragma mark - Sending Requests
/** @name Sending Requests */

/** Starts the request. */
-(void)start;

/** Cancels the request. */
-(void)cancel;

#pragma mark - Implementation
/** @name Implementation */

/**
 Constructs the URL request used for this request.
 
 Subclasses may override this message to customize behavior, although that should not be necessary.
 */
-(NSMutableURLRequest*)constructRequest;

/**
 Returns an array of URL-encoded pairs for constructing the parameter string.
 */
-(NSArray*)constructParameterPairs;

/**
 Returns the parameter string for the request.
 */
-(NSString*)constructParameterString;
 
#pragma mark - Subclass Implementation
/** @name Subclass Implementation */

/**
 Subclasses must override this message to provide a completion implementation for the request.
 
 @warning The default implementation throws an exception.
 
 @param data The data loaded by the request.
 @param response The HTTP response received for the request.
 */
-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response;

#pragma mark - Network Activity Indicator Delegate
/** @name Network Activity Indicator Delegate */

/**
 The current network activity indicator delegate. Defaults to `nil`.
 */
+(id<SVRequestNetworkActivityIndicatorDelegate>)networkActivityIndicatorDelegate;

/**
 Sets a network activity indicator delegate for all SVRequest instances.
 
 @param delegate The new network activity indicator delegate.
 */
+(void)setNetworkActivityIndicatorDelegate:(id<SVRequestNetworkActivityIndicatorDelegate>)delegate;

@end
