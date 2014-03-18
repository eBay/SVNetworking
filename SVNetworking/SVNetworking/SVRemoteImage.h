//
//  SVRemoteImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteDataRequestResource.h"
#import "SVRemoteScaledImageProtocol.h"

/**
 SVRemoteImage loads an image over the network from a URL. Observe the -image property with KVO or bindings.
 
 Images are cached to disk once loaded, and will be loaded from the cache if available.
 */
@interface SVRemoteImage : SVRemoteDataRequestResource <SVRemoteImageProtocol>

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

@end
