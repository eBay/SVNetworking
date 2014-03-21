//
//  SVRemoteImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVDiskCache.h"
#import "SVRemoteImage.h"

@interface SVRemoteImage ()

#pragma mark - URL
@property (nonatomic, strong) NSURL *URL;

#pragma mark - Scale
@property (nonatomic) CGFloat scale;

#pragma mark - Image
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteImage

#pragma mark - Disk Cache
+(SVDiskCache*)diskCache
{
    static SVDiskCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray* caches = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* path = [caches.firstObject stringByAppendingPathComponent:@"SVRemoteImage"];
        cache = [[SVDiskCache alloc] initWithPath:path];
    });
    
    return cache;
}

#pragma mark - Access
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL
{
    return [self cachedRemoteImageForURL:URL withScale:1];
}

+(instancetype)remoteImageForURL:(NSURL*)URL
{
    return [self remoteImageForURL:URL withScale:1];
}

+(instancetype)cachedRemoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale
{
    NSString *key = [NSString stringWithFormat:@"%f%@", scale, URL];
    
    return [self cachedResourceWithUniqueKey:key];
}

+(instancetype)remoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale
{
    NSString *key = [NSString stringWithFormat:@"%f%@", scale, URL];
    
    return [self resourceWithUniqueKey:key withInitializationBlock:^(SVRemoteImage *image) {
        image.URL = URL;
        image.scale = scale;
    }];
}

#pragma mark - Implementation - Custom Loading
-(void)beginLoading
{
    SVDiskCache *cache = [self.class diskCache];
    
    if ([cache hasDataForKey:self.uniqueKeyHash])
    {
        [self finishLoadingWithData:[cache dataForKey:self.uniqueKeyHash]];
    }
    else
    {
        [super beginLoading];
    }
}

#pragma mark - Implementation - Network Loading
-(SVDataRequest*)requestForNetworkLoading
{
    return [SVDataRequest GETRequestWithURL:_URL];
}

-(BOOL)parseFinishedData:(NSData*)data error:(NSError**)error
{
    UIImage *image = [[UIImage alloc] initWithData:data scale:_scale];
    
    if (image)
    {
        self.image = image;
        
        SVDiskCache *cache = [self.class diskCache];
        
        if (![cache hasDataForKey:self.uniqueKeyHash])
        {
            [cache writeData:data forKey:self.uniqueKeyHash];
        }
    }
    else if (error)
    {
        *error = [NSError errorWithDomain:@"com.svpply" code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"Failed to load image data"
        }];
    }
    
    return _image != nil;
}

@end
