//
//  SVRemoteImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVRemoteDataResource.h"

@interface SVRemoteImage : SVRemoteDataResource

#pragma mark - Access
+(instancetype)remoteImageForURL:(NSURL*)URL;

#pragma mark - URL
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Image
@property (nonatomic, readonly, strong) UIImage *image;

@end
