//
//  ILEScalingImageView.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <SVNetworking/SVNetworking.h>
#import "ILEScalingImageView.h"

@interface ILEScalingImageView ()
{
@private
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic) BOOL activityIndicatorAnimating;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic, strong) SVRemoteImage *remoteImage;

@end

@implementation ILEScalingImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // add loading indicator
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:_activityIndicatorView];
        
        // theoretically we should bind this too, to self.window.screen.scale, not sure if that all works with KVO
        CGFloat scale = [UIScreen mainScreen].scale;
        
        // bind the remote image
        NSArray *pairs = @[SVMultibindPair(self, @"boundsSize"),
                           SVMultibindPair(self, @"imageURL"),
                           SVMultibindPair(self, @"retainFullSizedImage")];
        
        [self sv_multibind:@"remoteImage" toObjectAndKeyPathPairs:pairs withBlock:^id(SVMultibindArray *values) {
            // unpack values
            CGSize size = [values[0] CGSizeValue];
            NSURL *URL = values[1];
            BOOL retainFullSizedImage = [values[2] boolValue];
            
            // transform to scaled image
            if (URL)
            {
                Class klass = retainFullSizedImage ? [SVRemoteRetainedScaledImage class] : [SVRemoteScaledImage class];
                return [[klass remoteScaledImageForURL:URL withScale:scale size:size] autoload];
            }
            else
            {
                return nil;
            }
        }];
        
        // bind the image
        [self sv_bind:@"image" toObject:self withKeyPath:@"remoteImage.image"];
        
        // bind loading indicator
        [self sv_bind:@"activityIndicatorAnimating" toObject:self withKeyPath:@"remoteImage.state" block:^id(id value) {
            return @([value intValue] == SVRemoteResourceStateLoading);
        }];
    }
    
    return self;
}

-(void)dealloc
{
    [self sv_unmultibindAll];
    [self sv_unbindAll];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    if (!CGSizeEqualToSize(bounds.size, _boundsSize))
    {
        self.boundsSize = bounds.size;
    }
}

-(BOOL)activityIndicatorAnimating
{
    return _activityIndicatorView.isAnimating;
}

-(void)setActivityIndicatorAnimating:(BOOL)activityIndicatorAnimating
{
    if (activityIndicatorAnimating)
    {
        [_activityIndicatorView startAnimating];
    }
    else
    {
        [_activityIndicatorView stopAnimating];
    }
}

@end
