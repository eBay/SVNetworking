//
//  SVRemoteResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "SVRemoteResource.h"

@interface SVRemoteResource ()

#pragma mark - State
@property (nonatomic) SVRemoteResourceState state;

#pragma mark - Error
@property (nonatomic) NSError *error;

@end

@implementation SVRemoteResource

#pragma mark - Unique Resources
+(NSMapTable*)uniqueTable
{
    static NSMapTable *resourceTable;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resourceTable = [NSMapTable strongToWeakObjectsMapTable];
    });
    
    return resourceTable;
}

+(instancetype)cachedResourceWithUniqueKey:(NSString*)uniqueKey
{
    return [[self uniqueTable] objectForKey:[self uniqueKeyHashForString:uniqueKey]];
}

+(instancetype)resourceWithUniqueKey:(NSString *)uniqueKey withInitializationBlock:(void (^)(id))block
{
    NSMapTable *resourceTable = [self uniqueTable];
    NSString *hash = [self uniqueKeyHashForString:uniqueKey];
    SVRemoteResource *resource = [resourceTable objectForKey:hash];
    
    if (!resource)
    {
        resource = [self new];
        
        if (resource)
        {
            resource->_uniqueKeyHash = hash;
            
            if (block)
            {
                block(resource);
            }
            
            [resourceTable setObject:resource forKey:hash];
        }
    }
    
    return resource;
}

+(NSString*)uniqueKeyHashForString:(NSString *)string
{
    // why we're not using NSString hash -> https://gist.github.com/fphilipe/3413755
    // note that the class name is prefixed
    
    const char* str = string.UTF8String;
    unsigned char result[16];
    CC_MD5(str, (unsigned int)strlen(str), result);
    return [NSString stringWithFormat:@"%@%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            self,
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

#pragma mark - Loading
-(void)load
{
    if (_state == SVRemoteResourceStateNotLoaded || _state == SVRemoteResourceStateError)
    {
        // clear error if applicable
        if (_error)
        {
            self.error = nil;
        }
        
        // update state
        self.state = SVRemoteResourceStateLoading;
        
        // custom or network loading
        [self beginLoading];
    }
}

-(instancetype)autoload
{
    [self load];
    return self;
}

-(void)reload
{
    if (_state != SVRemoteResourceStateLoading)
    {
        // clear error if applicable
        if (_error)
        {
            self.error = nil;
        }
        
        // update state
        self.state = SVRemoteResourceStateLoading;
        
        // custom or network loading
        [self beginLoading];
    }
}

#pragma mark - Implementation
-(void)finishLoading
{
    self.state = SVRemoteResourceStateFinished;
}

-(void)failLoadingWithError:(NSError *)error
{
    self.error = error;
    self.state = SVRemoteResourceStateError;
}

#pragma mark - Subclass Implementation
-(void)beginLoading
{
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Disk Cache
+(SVRemoteResourceDiskCache*)diskCache
{
    static SVRemoteResourceDiskCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *fileURL = [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"SVRemoteResource" isDirectory:YES];
        cache = [[SVRemoteResourceDiskCache alloc] initWithFileURL:fileURL];
    });
    
    return cache;
}

@end
