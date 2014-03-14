#import "SVJSONRequest.h"

@implementation SVJSONRequest

@dynamic delegate;

-(void)handleCompletionWithData:(NSData*)data response:(NSHTTPURLResponse*)response
{
    NSError* error = nil;
    id JSON = [self parseJSONData:data error:&error];
    
    if (!error)
    {
        [self.delegate request:self finishedWithJSON:JSON response:response];
    }
    else
    {
        [self.delegate request:self failedWithError:error];
    }
}

-(id)parseJSONData:(NSData*)data error:(__autoreleasing NSError**)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

@end
