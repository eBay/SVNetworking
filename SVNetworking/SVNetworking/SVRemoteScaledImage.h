//
//  SVRemoteScaledImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVRemoteProxyResource.h"

/**
 SVRemoteScaledImage loads an image over the network from a URL, and scales it to fit within the specified size.
 
 Observe the -image property with KVO or bindings.
 
 Internally, the class proxies SVRemoteImage, so images are cached to disk once loaded, and will be loaded from the
 cache if available.
 */
@interface SVRemoteScaledImage : SVRemoteProxyResource

#pragma mark - Access
/**
 Returns an (in-memory) cached remote image for the specified URL, scaled to the specified size.
 */
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size;

/**
 Returns a remote image for the specified URL, scaled to the specified size;
 */
+(instancetype)remoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size;

/**
 Returns an (in-memory) cached remote image for the specified URL, with the specified scale factor, scaled to the
 specified size.
 */
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size;

/**
 Returns a remote image for the specified URL, with the specified scale factor, scaled to the specified size;
 */
+(instancetype)remoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size;

#pragma mark - Image Size
/**
 The image size to scale to.
 */
@property (nonatomic, readonly) CGSize size;

#pragma mark - Image
/**
 The loaded image. This property is observable.
 */
@property (nonatomic, readonly, strong) UIImage *image;

@end
