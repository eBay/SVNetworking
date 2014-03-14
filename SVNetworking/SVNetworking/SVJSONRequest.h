#import "SVRequest.h"

@class SVJSONRequest;

@protocol SVJSONRequestDelegate <SVRequestDelegate>

-(void)request:(SVRequest*)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse*)response;

@end

@interface SVJSONRequest : SVRequest

@property (readwrite, weak) id<SVJSONRequestDelegate> delegate;

-(id)parseJSONData:(NSData*)data error:(__autoreleasing NSError**)error;

@end
