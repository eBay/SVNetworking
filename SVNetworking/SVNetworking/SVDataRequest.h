#import "SVRequest.h"

@class SVDataRequest;

@protocol SVDataRequestDelegate <SVRequestDelegate>

-(void)request:(SVDataRequest*)request finishedWithData:(NSData*)data response:(NSHTTPURLResponse*)response;

@end

@interface SVDataRequest : SVRequest

@property (readwrite, weak) id<SVDataRequestDelegate> delegate;

@end
