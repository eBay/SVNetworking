//
//  SVRemoteScaledImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVImageScaler.h"
#import "SVRemoteImage.h"
#import "SVRemoteRetainedScaledImage.h"

@interface SVRemoteRetainedScaledImage ()

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat scale;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteRetainedScaledImage

#pragma mark - Access
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size
{
    return [self cachedRemoteScaledImageForURL:URL withScale:1 size:size];
}

+(instancetype)remoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size
{
    return [self remoteScaledImageForURL:URL withScale:1 size:size];
}

+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size
{
    SVRemoteImage *image = [SVRemoteImage cachedRemoteImageForURL:URL withScale:scale];
    
    if (image)
    {
        return [self cachedResourceProxyingResource:image withAdditionalKey:NSStringFromCGSize(size)];
    }
    else
    {
        return nil;
    }
}

+(instancetype)remoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size
{
    SVRemoteImage *image = [SVRemoteImage remoteImageForURL:URL withScale:scale];
    
    return [self resourceProxyingResource:image
                        withAdditionalKey:NSStringFromCGSize(size)
                      initializationBlock:^(SVRemoteRetainedScaledImage *resource) {
        resource.size = size;
        resource.URL = URL;
        resource.scale = scale;
    }];
}

#pragma mark - Implementation
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
