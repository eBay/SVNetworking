#import "SVRequest.h"

@class SVDataRequest;

/**
 A delegate protocol for SVDataRequest objects.
 */
@protocol SVDataRequestDelegate <SVRequestDelegate>

/**
 Sent when the request finishes successfully.
 
 @param request The request.
 @param data The data object loaded by the request.
 @param response The HTTP response received by the request.
 */
-(void)request:(SVDataRequest*)request finishedWithData:(NSData*)data response:(NSHTTPURLResponse*)response;

@end

/**
 A request that loads data objects.
 */
@interface SVDataRequest : SVRequest

/**
 The delegate for the request.
 */
@property (readwrite, weak) id<SVDataRequestDelegate> delegate;

@end
