#import "SVRemoteResource.h"
#import "SVRemoteResourceDiskCache.h"

@interface SVRemoteResourceDiskCache ()
{
@private
    NSURL *_fileURL;
}

@end

@implementation SVRemoteResourceDiskCache

-(instancetype)initWithFileURL:(NSURL *)fileURL
{
    self = [self init];
    
    if (self)
    {
        _fileURL = fileURL;
        
        NSError *error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtURL:fileURL withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (success == NO)
        {
            NSLog(@"Error creating cache directory: %@", error);
        }
        
        _IOQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return self;
}

-(void)dataForResource:(SVRemoteResource *)remoteResource
            completion:(SVRemoteResourceCacheReadCompletionBlock)completion
               failure:(SVRemoteResourceCacheFailureBlock)failure
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:remoteResource.uniqueKeyHash isDirectory:NO];
    
    dispatch_async(_IOQueue, ^{
        NSError *error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfURL:fileURL options:NSDataReadingUncached error:&error];
        
        if (data)
        {
            if (completion)
            {
                completion(data);
            }
        }
        else
        {
            if (failure)
            {
                failure(error);
            }
        }
    });
}

-(void)writeData:(NSData*)data
     forResource:(SVRemoteResource *)remoteResource
      completion:(SVRemoteResourceCacheWriteCompletionBlock)completion
         failure:(SVRemoteResourceCacheFailureBlock)failure;
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:remoteResource.uniqueKeyHash isDirectory:NO];
    
    dispatch_async(_IOQueue, ^{
        NSError *error = nil;
        BOOL success = [data writeToURL:fileURL options:(NSDataWritingAtomic|NSDataWritingFileProtectionComplete) error:&error];
        
        if (success)
        {
            if (completion)
            {
                completion();
            }
        }
        else
        {
            if (failure)
            {
                failure(error);
            }
        }
    });
}

@end
