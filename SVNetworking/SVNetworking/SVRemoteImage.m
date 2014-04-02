//
//  SVRemoteImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

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
