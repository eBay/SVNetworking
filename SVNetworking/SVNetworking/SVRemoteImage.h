//
//  SVRemoteImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVRemoteDataResource.h"

/**
 SVRemoteImage loads an image over the network from a URL. Observe the -image property with KVO or bindings.
 
 Images are cached to disk once loaded, and will be loaded from the cache if available.
 */
@interface SVRemoteImage : SVRemoteDataResource

#pragma mark - Access
/**
 Returns an (in-memory) cached remote image for the specified URL.
 */
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL;

/**
 Returns a remote image for the specified URL.
 */
+(instancetype)remoteImageForURL:(NSURL*)URL;

/**
 Returns an (in-memory) cached remote image for the specified URL, with the specified scale.
 */
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale;

/**
 Returns a remote image for the specified URL, with the specified scale.
 */
+(instancetype)remoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale;

#pragma mark - URL
/**
 The image URL to load from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Scale
/**
 The scale factor for the image.
 */
@property (nonatomic, readonly) CGFloat scale;

#pragma mark - Image
/**
 The loaded image. This property is observable.
 */
@property (nonatomic, readonly, strong) UIImage *image;

@end
