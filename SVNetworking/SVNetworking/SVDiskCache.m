#import "SVDiskCache.h"

@interface SVDiskCache ()
{
@private
    NSString *_path;
}

@end

@implementation SVDiskCache

-(id)initWithPath:(NSString*)path
{
    self = [self init];
    
    if (self)
    {
        _path = path;
        
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error)
        {
            NSLog(@"Error creating cache directory: %@", error);
        }
    }
    
    return self;
}

-(NSData*)dataForKey:(NSString*)key
{
    NSString *filePath = [_path stringByAppendingPathComponent:key];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL])
    {
        return [[NSData alloc] initWithContentsOfFile:filePath];
    }
    else
    {
        return nil;
    }
}

-(void)writeData:(NSData*)data forKey:(NSString*)key
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data writeToFile:[_path stringByAppendingPathComponent:key] atomically:YES];
    });
}

-(BOOL)hasDataForKey:(NSString*)key
{
    NSString *filePath = [_path stringByAppendingPathComponent:key];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL];
}

@end
