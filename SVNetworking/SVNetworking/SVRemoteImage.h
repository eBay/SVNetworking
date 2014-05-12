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

#import "SVRemoteResourceDiskCache.h"
#import "SVRemoteDataRequestResource.h"
#import "SVRemoteScaledImageProtocol.h"

/**
 SVRemoteImage loads an image over the network from a URL. Observe the -image property with KVO or bindings.
 
 Images are cached to disk once loaded, and will be loaded from the cache if available.
 */
@interface SVRemoteImage : SVRemoteDataRequestResource <SVRemoteImageProtocol>

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
