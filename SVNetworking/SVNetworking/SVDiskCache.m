#import "SVDiskCache.h"

@interface SVDiskCache ()
{
@private
    NSURL *_fileURL;
}

@end

@implementation SVDiskCache

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
    }
    
    return self;
}

-(NSData*)dataForKey:(NSString*)key error:(NSError **)error
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:key isDirectory:NO];
    
    return [[NSData alloc] initWithContentsOfURL:fileURL options:NSDataReadingUncached error:error];
}

-(BOOL)writeData:(NSData*)data forKey:(NSString*)key error:(NSError **)error
{
    NSURL *fileURL = [_fileURL URLByAppendingPathComponent:key isDirectory:NO];
    
    return [data writeToURL:fileURL options:(NSDataWritingAtomic|NSDataWritingFileProtectionComplete) error:error];
}

@end
