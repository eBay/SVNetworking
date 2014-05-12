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
+(NSString*)additionalKeyForSize:(CGSize)size withScale:(CGFloat)scale
{
    return [NSString stringWithFormat:@"%f,%f,%f", size.width, size.height, scale];
}

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
        NSString *key = [self additionalKeyForSize:size withScale:scale];
        return [self cachedResourceProxyingResource:image withAdditionalKey:key];
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
                        withAdditionalKey:[self additionalKeyForSize:size withScale:scale]
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
