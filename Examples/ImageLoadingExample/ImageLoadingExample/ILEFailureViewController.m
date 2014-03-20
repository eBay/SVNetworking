//
//  ILEFailureViewController.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/20/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <SVNetworking/SVNetworking.h>

#import "ILEFailureViewController.h"

@interface ILEFailureViewController ()
{
@private
    IBOutlet SVImageView *_scalingImageView;
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
