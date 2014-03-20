//
//  ILEScalingImageView.h
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SVImageView is a remote image view, backed by the scaling proxy image classes (which are, in turn, backed by
 SVRemoteImage).
 
 Images are automatically scaled to fit within the image view, and will be rescaled if the image view changes size.
 */
@interface SVImageView : UIImageView

#pragma mark - Image URL
/**
 The image URL for the current image.
 */
@property (nonatomic, strong) NSURL *imageURL;

#pragma mark - Full-Size Image Retention
/**
 If YES, SVRemoteRetainedScaledImage will be used to load images. Otherwise, SVRemoteScaledImage will be used.
 
 Defaults to NO.
 */
@property (nonatomic) BOOL retainFullSizedImage;

#pragma mark - Activity Indicator
/**
 The activity indicator style to display while loading images.
 
 Defaults to UIActivityIndicatorViewStyleGray.
 */
@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

#pragma mark - Failure Image
/**
 An optional image that will be displayed if the remote image fails to load.
 */
@property (nonatomic, strong) UIImage *failureImage;

/**
 The content mode that should be used for displaying failure images.
 
 Defaults to UIViewContentModeCenter.
 */
@property (nonatomic) UIViewContentMode failureImageContentMode;

@end
