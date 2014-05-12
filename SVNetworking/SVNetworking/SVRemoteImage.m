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
#import "SVRemoteImage.h"

@interface SVRemoteImage ()
{
@private
    BOOL _loadingViaNetwork;
}

#pragma mark - URL
@property (nonatomic, strong) NSURL *URL;

#pragma mark - Scale
@property (nonatomic) CGFloat scale;

#pragma mark - Image
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteImage

#pragma mark - Access
+(instancetype)cachedRemoteImageForURL:(NSURL*)URL
{
    return [self cachedRemoteImageForURL:URL withScale:1];
}

+(instancetype)remoteImageForURL:(NSURL*)URL
{
    return [self remoteImageForURL:URL withScale:1];
}

+(instancetype)cachedRemoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale
{
    NSString *key = [NSString stringWithFormat:@"%f%@", scale, URL];
    
    return [self cachedResourceWithUniqueKey:key];
}

+(instancetype)remoteImageForURL:(NSURL*)URL withScale:(CGFloat)scale
{
    NSString *key = [NSString stringWithFormat:@"%f%@", scale, URL];
    
    return [self resourceWithUniqueKey:key withInitializationBlock:^(SVRemoteImage *image) {
        image.URL = URL;
        image.scale = scale;
    }];
}

#pragma mark - Implementation - Custom Loading
-(void)beginLoading
{
    SVRemoteResourceDiskCache *cache = [self.class diskCache];
    
    [cache dataForResource:self completion:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_loadingViaNetwork = NO;
            [self finishLoadingWithData:data];
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_loadingViaNetwork = YES;
            [super beginLoading];
        });
    }];
}

#pragma mark - Implementation - Network Loading
-(SVDataRequest*)requestForNetworkLoading
{
    return [SVDataRequest GETRequestWithURL:_URL];
}

-(BOOL)parseFinishedData:(NSData*)data error:(__autoreleasing NSError**)error
{
    UIImage *image = [[UIImage alloc] initWithData:data scale:_scale];
    
    if (image)
    {
        self.image = image;
        
        if (_loadingViaNetwork)
        {
            SVRemoteResourceDiskCache *cache = [self.class diskCache];
            [cache writeData:data forResource:self completion:nil failure:nil];
        }
    }
    else if (error)
    {
        *error = [NSError errorWithDomain:@"com.svpply" code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"Failed to load image data"
        }];
    }
    
    return _image != nil;
}

@end
