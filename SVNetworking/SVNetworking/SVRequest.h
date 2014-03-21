#import <TargetConditionals.h>

typedef enum
{
    SVRequestMethodGET,
    SVRequestMethodPOST,
    SVRequestMethodPUT,
    SVRequestMethodDELETE
} SVRequestMethod;

@protocol SVRequestNetworkActivityIndicatorDelegate <NSObject>

-(void)increaseNetworkActivityIndicatorCount;
-(void)decreaseNetworkActivityIndicatorCount;

@end

FOUNDATION_EXTERN NSString* SVStringForRequestMethod(SVRequestMethod method);

@class SVRequest;

@protocol SVRequestDelegate <NSObject>

@required
-(void)request:(SVRequest*)request failedWithError:(NSError*)error;

@optional
-(void)request:(SVRequest*)request receivedResponse:(NSURLResponse*)response willUpdateProgress:(BOOL)willUpdateProgress;
-(void)request:(SVRequest*)request updatedUploadProgress:(double)progress;
-(void)request:(SVRequest*)request updatedDownloadProgress:(double)progress;

@end

@interface SVRequest : NSObject

#pragma mark - Raw Data
@property (readwrite, strong) NSData* bodyData;
@property (readwrite, strong) NSString* contentType;

#pragma mark - Keyed Data
-(id)objectForKeyedSubscript:(id)key;
-(void)setObject:(id)value forKeyedSubscript:(id<NSCopying>)key;

#pragma mark - Delegation
@property (readwrite, weak) id<SVRequestDelegate> delegate;

#pragma mark - URL and Method
@property (readonly, strong) NSURL* URL;
@property (readonly) SVRequestMethod method;

#pragma mark - Construction
+(instancetype)requestWithURL:(NSURL*)URL method:(SVRequestMethod)method;

#pragma mark - Construction - GET
+(instancetype)GETRequestWithURL:(NSURL*)URL;

#pragma mark - Construction - POST
+(instancetype)POSTRequestWithURL:(NSURL*)URL;

#pragma mark - Construction - PUT
+(instancetype)PUTRequestWithURL:(NSURL*)URL;

#pragma mark - Construction - DELETE
+(instancetype)DELETERequestWithURL:(NSURL*)URL;

#pragma mark - Sending
-(void)start;
-(void)cancel;

#pragma mark - Subclass Implementation
-(NSMutableURLRequest*)constructRequest;
-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response;

#pragma mark - Network Activity Indicator Delegate
+(id<SVRequestNetworkActivityIndicatorDelegate>)networkActivityIndicatorDelegate;
+(void)setNetworkActivityIndicatorDelegate:(id<SVRequestNetworkActivityIndicatorDelegate>)delegate;

@end
