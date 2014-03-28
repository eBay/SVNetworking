//
//  SVRemoteImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVDiskCache.h"
#import "SVRemoteDataRequestResource.h"
#import "SVRemoteScaledImageProtocol.h"

/**
 SVRemoteImage loads an image over the network from a URL. Observe the -image property with KVO or bindings.
 
 Images are cached to disk once loaded, and will be loaded from the cache if available.
 */
@interface SVRemoteImage : SVRemoteDataRequestResource <SVRemoteImageProtocol>

#pragma mark - Disk Cache
/** @name Disk Cache */

/**
 The cache for downloaded image data.
 */
+(SVDiskCache*)diskCache;

#pragma mark - Access
/** @name Access */

/**
 Returns an (in-memory) cached remote image for the specified URL.
 
 This image will have a `scale` value of 1.
 
 @param URL The URL for the image.
 */
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL;

/**
 Returns a remote image for the specified URL.
 
 This image will have a `scale` value of 1.
 
 @param URL The URL for the image.
 */
+(instancetype)remoteImageForURL:(NSURL*)URL;

/**
 Returns an (in-memory) cached remote image for the specified URL, with the specified scale.
 
 @param URL The URL for the image.
 @param scale The scale for the image.
 */
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale;

/**
 Returns a remote image for the specified URL, with the specified scale.
 
 @param URL The URL for the image.
 @param scale The scale for the image.
 */
+(instancetype)remoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale;

@end
