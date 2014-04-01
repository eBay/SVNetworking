#import "SVRemoteResourceCache.h"

@interface SVRemoteResourceDiskCache : NSObject <SVRemoteResourceCache>

/**
 Initializes a disk cache instance.
 
 @param fileURL The base directory URL for the cache. This directory will be created if necessary.
 */
-(instancetype)initWithFileURL:(NSURL *)fileURL;

#pragma mark - IO Queue
/**
 The IO queue to perform data reads and writes on.
 
 This defaults to the `DISPATCH_QUEUE_PRIORITY_DEFAULT` global queue.
 */
@property (nonatomic, strong) dispatch_queue_t IOQueue;

@end
