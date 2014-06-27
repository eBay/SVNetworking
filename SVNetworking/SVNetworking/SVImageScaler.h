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

#import "SVImageClass.h"

/**
 Provides image scaling class methods.
 */
@interface SVImageScaler : NSObject

/**
 Synchronously scales an image to the specified size and scale.
 
 @param image The source image.
 @param size The destination size to fit to.
 @param scale The `scale` of the destination image.
 @returns A scaled image.
 */
+(SV_IMAGE_CLASS*)scaleImage:(SV_IMAGE_CLASS*)image toSize:(CGSize)size withScale:(CGFloat)scale;

/**
 Asynchronously scales an image to the specified size and scale.
 
 @param image The source image.
 @param size The destination size to fit to.
 @param scale The `scale` of the destination image.
 @param completion A completion handler, which will be called on the main thread.
 */
+(void)scaleImage:(SV_IMAGE_CLASS*)image toSize:(CGSize)size withScale:(CGFloat)scale completion:(void(^)(SV_IMAGE_CLASS *scaledImage))completion;

@end
