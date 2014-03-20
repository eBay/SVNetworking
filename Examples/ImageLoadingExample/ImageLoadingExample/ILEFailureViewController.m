//
//  ILEFailureViewController.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/20/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "ILEFailureViewController.h"
#import "ILEScalingImageView.h"

@interface ILEFailureViewController ()
{
@private
    IBOutlet ILEScalingImageView *_scalingImageView;
}

@end

@implementation ILEFailureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scalingImageView.imageURL = [NSURL URLWithString:@"http://notadomain/notanimage"];
    _scalingImageView.failureImage = [UIImage imageNamed:@"Failure"];
}

@end
