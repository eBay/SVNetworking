//
//  ILEViewController.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <SVNetworking/SVNetworking.h>

#import "ILERemoteImageView.h"
#import "ILEBasicViewController.h"

@interface ILEBasicViewController ()
{
@private
    IBOutlet ILERemoteImageView *_topView;
    IBOutlet ILERemoteImageView *_bottomView;
}

@end

@implementation ILEBasicViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *URL = [NSURL URLWithString:@"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr03/5/11/enhanced-buzz-22866-1386260133-20.jpg"];
    
    _topView.remoteImage = [SVRemoteImage remoteImageForURL:URL];
    _bottomView.remoteImage = [SVRemoteScaledImage remoteScaledImageForURL:URL withSize:_bottomView.bounds.size];
}

@end
