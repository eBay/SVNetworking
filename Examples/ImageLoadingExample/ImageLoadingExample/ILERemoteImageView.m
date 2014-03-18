//
//  ILERemoteImageView.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "ILERemoteImageView.h"

@implementation ILERemoteImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self sv_bind:@"image" toObject:self withKeyPath:@"remoteImage.image"];
    }
    
    return self;
}

-(void)dealloc
{
    [self sv_unbindAll];
}

-(void)setRemoteImage:(SVRemoteResource<SVRemoteImageProtocol> *)remoteImage
{
    _remoteImage = remoteImage;
    [_remoteImage load];
}

@end
