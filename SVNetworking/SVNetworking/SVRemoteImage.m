//
//  SVRemoteImage.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteImage.h"

@interface SVRemoteImage ()

#pragma mark - URL
@property (nonatomic, strong) NSURL *URL;

#pragma mark - Image
@property (nonatomic, strong) UIImage *image;

@end

@implementation SVRemoteImage

#pragma mark - Access
+(instancetype)remoteImageForURL:(NSURL*)URL
{
    return [self resourceWithKey:[self keyForString:URL.absoluteString] withInitializationBlock:^(SVRemoteImage *image) {
        image.URL = URL;
    }];
}

#pragma mark - Implementation
-(SVDataRequest*)requestForNetworkLoading
{
    return [SVDataRequest GETRequestWithURL:_URL];
}

-(void)finishWithData:(NSData*)data error:(NSError**)error
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    if (image)
    {
        self.image = image;
    }
    else
    {
        *error = [NSError errorWithDomain:@"com.svpply" code:0 userInfo:@{}];
    }
}

@end
