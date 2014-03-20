//
//  ILEScalingImageView.h
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILEScalingImageView : UIImageView

#pragma mark - Image URL
@property (nonatomic, strong) NSURL *imageURL;

#pragma mark - Full-Size Image Retention
@property (nonatomic) BOOL retainFullSizedImage;

#pragma mark - Activity Indicator
@property (nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

#pragma mark - Failure Image
@property (nonatomic, strong) UIImage *failureImage;

@end
