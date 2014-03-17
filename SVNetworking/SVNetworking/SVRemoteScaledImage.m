//
//  SVRemoteScaledImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteImage.h"
#import "SVRemoteScaledImage.h"

@interface SVRemoteScaledImage ()

@property (nonatomic) CGSize size;
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteScaledImage

#pragma mark - Access
+(instancetype)cachedRemoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size
{
    SVRemoteImage *image = [SVRemoteImage cachedRemoteImageForURL:URL];
    
    if (image)
    {
        return [self cachedResourceProxyingResource:image withAdditionalKey:NSStringFromCGSize(size)];
    }
    else
    {
        return nil;
    }
}

+(instancetype)remoteScaledImageForURL:(NSURL*)URL withSize:(CGSize)size;
{
    SVRemoteImage *image = [SVRemoteImage remoteImageForURL:URL];
    
    return [self resourceProxyingResource:image
                        withAdditionalKey:NSStringFromCGSize(size)
                      initializationBlock:^(SVRemoteScaledImage *resource) {
        resource.size = size;
    }];
}

#pragma mark - Implementation
-(void)parseFinishedProxiedResource:(SVRemoteImage*)proxiedResource error:(NSError**)error
{
    // obviously, we need to actually scale here... some additions we can make for concurrency as well
    self.image = proxiedResource.image;
}

@end
