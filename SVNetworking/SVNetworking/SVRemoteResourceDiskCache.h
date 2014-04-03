#import "SVRemoteResourceCache.h"

/**
 A disk cache for remote resources.
 
 The resource's -[SVRemoteResource uniqueKeyHash] is used as a filename for items in the cache.
 */
@interface SVRemoteResourceDiskCache : NSObject <SVRemoteResourceCache>

#pragma mark - Initialization
/** @name Initialization */

/**
 Initializes a disk cache instance.
 
 @param fileURL The base directory URL for the cache. This directory will be created if necessary.
 */
-(instancetype)initWithFileURL:(NSURL *)fileURL;

#pragma mark - IO Queue
/** @name IO Queue */

/**
 The IO queue to perform data reads and writes on.
 
 This defaults to the `DISPATCH_QUEUE_PRIORITY_DEFAULT` global queue.
 */
@property (nonatomic, strong) dispatch_queue_t IOQueue;

@end
