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
        NSString* path = [caches.firstObject stringByAppendingPathComponent:@"SVImageLoader"];
        cache = [[SVDiskCache alloc] initWithPath:path];
    });
    
    return cache;
}

#pragma mark - Access
+(instancetype)remoteImageForURL:(NSURL*)URL
{
    return [self resourceWithUniqueKey:[self uniqueKeyForString:URL.absoluteString] withInitializationBlock:^(SVRemoteImage *image) {
        image.URL = URL;
    }];
}

#pragma mark - Implementation - Custom Loading
-(void)beginLoading
{
    SVDiskCache *cache = [self.class diskCache];
    
    if ([cache hasDataForKey:self.uniqueKey])
    {
        [self finishLoadingWithData:[cache dataForKey:self.uniqueKey]];
    }
    else
    {
        [super beginLoading];
    }
}

-(SVDataRequest*)requestForNetworkLoading
{
    return [SVDataRequest GETRequestWithURL:_URL];
}

-(void)finishWithData:(NSData*)data error:(NSError**)error
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (image)
    {
        self.image = image;
        
        SVDiskCache *cache = [self.class diskCache];
        
        if (![cache hasDataForKey:self.uniqueKey])
        {
            [cache writeData:data forKey:self.uniqueKey];
        }
    }
    else
    {
        *error = [NSError errorWithDomain:@"com.svpply" code:0 userInfo:@{}];
    }
}

@end
