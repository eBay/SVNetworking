#import "SVDataRequest.h"

@implementation SVDataRequest

@dynamic delegate;

-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
    [self.delegate request:self finishedWithData:data response:response];
}

@end
