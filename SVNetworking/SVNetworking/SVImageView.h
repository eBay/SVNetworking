//
//  ILEScalingImageView.h
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteImageProtocol.h"
#import "SVRemoteResource.h"

/**
 SVImageView is a remote image view, backed by the scaling proxy image classes (which are, in turn, backed by
 SVRemoteImage).
 
 Images are automatically scaled to fit within the image view, and will be rescaled if the image view changes size.
 */
@interface SVImageView : UIImageView

#pragma mark - Image URL
/** @name Image URL */

/**
 The image URL for the current image.
 */
@property (nonatomic, strong) NSURL *imageURL;

#pragma mark - Remote Image
/**
 The remote image currently associated with the image view. The actual implementation class will vary.
 
 Subclasses can use this property to implement custom failure/retry interfaces, etc.
 */
@property (nonatomic, readonly, strong) SVRemoteResource<SVRemoteImageProtocol> *remoteImage;

#pragma mark - Image Content Mode
/** @name Image Content Mode */

/**
 The content mode that should be used for displaying successfully loaded remote images
 
 Defaults to UIViewContentModeCenter.
 */
@property (nonatomic) UIViewContentMode imageContentMode;

#pragma mark - Full-Size Image Retention
/** @name Full-Size Image Retention */

/**
 If YES, SVRemoteRetainedScaledImage will be used to load images. Otherwise, SVRemoteScaledImage will be used.
 
 Defaults to NO.
 */
@property (nonatomic) BOOL retainFullSizedImage;

#pragma mark - Activity Indicator
/** @name Activity Indicator */

/**
 The activity indicator style to display while loading images.
 
 Defaults to UIActivityIndicatorViewStyleGray.
 */
@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

#pragma mark - Empty Image
/** @name Empty Image */

/**
 An optional image that will be displayed if the remote image URL is nil.
 */
@property (nonatomic, strong) UIImage *emptyImage;

/**
 The content mode that should be used for displaying empty images.
 
 Defaults to UIViewContentModeScaleAspectFit.
 */
@property (nonatomic) UIViewContentMode emptyImageContentMode;

#pragma mark - Failure Image
/** @name Failure Image */

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
