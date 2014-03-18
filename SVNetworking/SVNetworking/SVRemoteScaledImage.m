//
//  SVRemoteScaledImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteImage.h"
#import "SVRemoteScaledImage.h"

@interface SVRemoteScaledImage ()

@property (nonatomic) CGSize size;
@property (nonatomic) NSURL *URL;
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
                      initializationBlock:^(SVRemoteScaledImage *resource) {
        resource.size = size;
        resource.URL = URL;
    }];
}

#pragma mark - Implementation
-(void)parseFinishedProxiedResource:(SVRemoteImage*)proxiedResource
                       withListener:(id<SVRemoteProxyResourceCompletionListener>)listener
{
    UIImage *image = proxiedResource.image;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // calculate the correct image size to scale to
        CGSize const imageSize = image.size;
        CGFloat ratio = MIN(_size.width / imageSize.width, _size.height / imageSize.height);
        CGSize fitSize = {
            roundf(imageSize.width * ratio),
            roundf(imageSize.height * ratio)
        };
        
        // scale the image
        UIGraphicsBeginImageContext(fitSize);
        [image drawInRect:CGRectMake(0.0, 0.0, fitSize.width, fitSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // move back to the main thread for completion
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = scaledImage;
            
            // tell the listener we're done
            [listener remoteProxyResourceFinished];
        });
    });
}

@end
