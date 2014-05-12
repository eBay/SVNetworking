/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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

#pragma mark - Size
/** @name Size */

/** The size that the resource will scale its image to fit within. */
@property (nonatomic, readonly) CGSize size;

@end
