//
//  ILEScalingViewController.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "ILEScalingImageView.h"
#import "ILEScalingViewController.h"

@interface ILEScalingViewController ()
{
@private
    UIControl *_control;
    ILEScalingImageView *_imageView;
}

@end

@implementation ILEScalingViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    _control = [[UIControl alloc] initWithFrame:self.view.bounds];
    _control.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_control];
    
    _imageView = [[ILEScalingImageView alloc] initWithFrame:_control.bounds];
    _imageView.userInteractionEnabled = NO;
    _imageView.backgroundColor = [UIColor redColor];
    _imageView.contentMode = UIViewContentModeCenter;
    [_control addSubview:_imageView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self controlAction];
    
    _imageView.URL = [NSURL URLWithString:@"http://s3-ec.buzzfed.com/static/2013-12/enhanced/webdr05/5/14/enhanced-buzz-19728-1386270926-14.jpg"];
}

-(void)controlAction
{
    CGRect bounds = _control.bounds;
    bounds.size.width /= 2;
    bounds.size.height /= 2;
    bounds.size.width += rand() % (int)bounds.size.width;
    bounds.size.height += rand() % (int)bounds.size.height;
    
    _imageView.frame = bounds;
}

@end
