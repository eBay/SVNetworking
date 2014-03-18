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
    IBOutlet UISwitch *_scalingSwitch;
    NSURL *_URL;
}

@end

@implementation ILEBasicViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _URL = [NSURL URLWithString:@"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr03/5/11/enhanced-buzz-22866-1386260133-20.jpg"];
    
    _topView.remoteImage = [SVRemoteImage remoteImageForURL:_URL];
    _bottomView.remoteImage = [SVRemoteScaledImage remoteScaledImageForURL:_URL withSize:_bottomView.bounds.size];
}

-(IBAction)scalingSwitchAction:(id)sender
{
    if (_scalingSwitch.on)
    {
        _bottomView.remoteImage = [SVRemoteScaledImage remoteScaledImageForURL:_URL
                                                                     withScale:[UIScreen mainScreen].scale
                                                                          size:_bottomView.bounds.size];
    }
    else
    {
        _bottomView.remoteImage = [SVRemoteScaledImage remoteScaledImageForURL:_URL withSize:_bottomView.bounds.size];
    }
}

@end
