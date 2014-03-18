//
//  SVRemoteImageProtocol.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This protocol provides the default shared properties for all networked images.
 */
@protocol SVRemoteImageProtocol <NSObject>

#pragma mark - URL
/**
 The image URL to load from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Scale
/**
 The scale factor for the image.
 */
@property (nonatomic, readonly) CGFloat scale;

#pragma mark - Image
/**
 The loaded image. This property is observable.
 */
@property (nonatomic, readonly, strong) UIImage *image;

@end
