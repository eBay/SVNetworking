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

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

#import "SVRemoteImageProtocol.h"
#import "SVRemoteResource.h"

/**
 SVImageView is a remote image view, backed by the scaling proxy image classes (which are, in turn, backed by
 SVRemoteImage).
 
 Images are automatically scaled to fit within the image view, and will be rescaled if the image view changes size.
 */
@interface SVImageView : UIView

#pragma mark - Image
/** @name Image */

/**
 The current image, or `nil`.
 */
@property (nonatomic, readonly, strong) UIImage *image;

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

#endif