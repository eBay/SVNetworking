//
//  SVRemoteScaledImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVImageScaler.h"
#import "SVRemoteImage.h"
#import "SVRemoteScaledImage.h"

@interface SVRemoteScaledImage ()

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteScaledImage

#pragma mark - Access
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size
{
    return [self cachedRemoteScaledImageForURL:URL withScale:1 size:size];
}

+(instancetype)remoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size
{
    return [self remoteScaledImageForURL:URL withScale:1 size:size];
}

+(NSString*)uniqueKeyForURL:(NSURL*)URL scale:(CGFloat)scale size:(CGSize)size
{
    return [NSString stringWithFormat:@"%f,%f,%f,%@", scale, size.width, size.height, URL];
}

+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size
{
    NSString *key = [self uniqueKeyForURL:URL scale:scale size:size];
    return [self cachedResourceWithUniqueKey:key];
}

+(instancetype)remoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size
{
    NSString *key = [self uniqueKeyForURL:URL scale:scale size:size];
    
    return [self resourceWithUniqueKey:key withInitializationBlock:^(SVRemoteScaledImage *resource) {
        resource.size = size;
        resource.scale = scale;
        resource.URL = URL;
    }];
}

#pragma mark - Implementation - Proxy
-(SVRemoteResource*)acquireProxiedResource
{
    return [SVRemoteImage remoteImageForURL:_URL withScale:_scale];
}

#pragma mark - Implementation - Parsing
-(void)parseFinishedProxiedResource:(SVRemoteImage*)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener
{
    UIImage *image = proxiedResource.image;
    
    [SVImageScaler scaleImage:image toSize:_size withScale:_scale completion:^(UIImage *scaledImage) {
        // assign image property
        self.image = scaledImage;
        
        // tell the listener we're done
        [listener remoteProxyResourceFinished];
    }];
}

@end
