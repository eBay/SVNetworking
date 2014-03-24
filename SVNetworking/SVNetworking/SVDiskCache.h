#import <Foundation/Foundation.h>

@interface SVDiskCache : NSObject

-(instancetype)initWithFileURL:(NSURL *)fileURL;

#pragma mark - IO Queue
@property (nonatomic, strong) dispatch_queue_t IOQueue;

#pragma mark - IO
-(void)dataForKey:(NSString*)key completion:(void(^)(NSData *data))completion failure:(void(^)(NSError *error))failure;
-(void)writeData:(NSData*)data forKey:(NSString*)key completion:(void(^)())completion failure:(void(^)(NSError *error))failure;

@end
