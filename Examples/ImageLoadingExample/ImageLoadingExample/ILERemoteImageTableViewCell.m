//
//  ILERemoteImageTableViewCell.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "ILERemoteImageTableViewCell.h"

@implementation ILERemoteImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self sv_bind:@"imageView.image" toObject:self withKeyPath:@"remoteImage.image"];
        [self addObserver:self forKeyPath:@"imageView.image" options:0 context:NULL];
    }
    
    return self;
}

-(void)dealloc
{
    [self sv_unbindAll];
    [self removeObserver:self forKeyPath:@"imageView.image"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"imageView.image"])
    {
        [self setNeedsLayout];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
