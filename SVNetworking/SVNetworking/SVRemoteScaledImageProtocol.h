//
//  SVRemoteScaledImageProtocol.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteImageProtocol.h"

/**
 This protocol provides the default access messages for acquiring scaled remote images.
 
 It also inherits the SVRemoteImageProtocol's default properties, shared among all remote images.
 */
@protocol SVRemoteScaledImageProtocol <SVRemoteImageProtocol>

#pragma mark - Access
/** @name Access */

/**
 Returns an (in-memory) cached remote image for the specified URL, scaled to the specified size.
 
 This image has an implicit `scale` of 1.
 
 @param URL The URL for the image.
 @param size The size to scale to.
 */
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size;

/**
 Returns a remote image for the specified URL, scaled to the specified size;
 
 This image has an implicit `scale` of 1.
 
 @param URL The URL for the image.
 @param size The size to scale to.
 */
+(instancetype)remoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size;

/**
 Returns an (in-memory) cached remote image for the specified URL, with the specified scale factor, scaled to the
 specified size.
 
 @param URL The URL for the image.
 @param scale The scale factor for the image.
 @param size The size to scale to.
 */
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size;

/**
 Returns a remote image for the specified URL, with the specified scale factor, scaled to the specified size;
 
 @param URL The URL for the image.
 @param scale The scale factor for the image.
 @param size The size to scale to.
 */
+(instancetype)remoteScaledImageForURL:(NSURL*)URL withScale:(CGFloat)scale size:(CGSize)size;

@end
