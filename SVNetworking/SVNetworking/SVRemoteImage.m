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
{
@private
    BOOL _loadingViaNetwork;
}

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
        NSURL *fileURL = [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains: NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"SVRemoteImage" isDirectory:YES];
        cache = [[SVDiskCache alloc] initWithFileURL:fileURL];
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
    
    [cache dataForKey:self.uniqueKeyHash completion:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _loadingViaNetwork = NO;
            [self finishLoadingWithData:data];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _loadingViaNetwork = YES;
            [super beginLoading];
        });
    }];
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
        
        if (_loadingViaNetwork)
        {
            SVDiskCache *cache = [self.class diskCache];
            [cache writeData:data forKey:self.uniqueKeyHash completion:nil failure:nil];
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
