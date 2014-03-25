//
//  ILEScalingImageView.m
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "NSObject+SVBindings.h"
#import "NSObject+SVMultibindings.h"
#import "SVRemoteScaledImage.h"
#import "SVRemoteRetainedScaledImage.h"
#import "SVImageView.h"

@interface SVImageView ()
{
@private
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic) BOOL activityIndicatorAnimating;
@property (nonatomic) CGSize boundsSize;
@property (nonatomic, strong) SVRemoteResource<SVRemoteImageProtocol> *remoteImage;

@end

@implementation SVImageView

-(void)sharedInit
{
    // default content mode is center
    _imageContentMode = UIViewContentModeCenter;
    _failureImageContentMode = UIViewContentModeCenter;
    
    // add loading indicator
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:_activityIndicatorView];
    
    // theoretically we should bind this too, to self.window.screen.scale, not sure if that all works with KVO
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // bind the remote image
    NSArray *pairs = @[SVMultibindPair(self, SV_KEYPATH(self, boundsSize)),
                       SVMultibindPair(self, SV_KEYPATH(self, imageURL)),
                       SVMultibindPair(self, SV_KEYPATH(self, retainFullSizedImage))];
    
    [self sv_multibind:SV_KEYPATH(self, remoteImage) toObjectAndKeyPathPairs:pairs withBlock:^id(SVMultibindArray *values) {
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
    pairs = @[SVMultibindPair(self, SV_KEYPATH(self, remoteImage.state)),
              SVMultibindPair(self, SV_KEYPATH(self, remoteImage.image)),
              SVMultibindPair(self, SV_KEYPATH(self, emptyImage)),
              SVMultibindPair(self, SV_KEYPATH(self, failureImage))];
    
    [self sv_multibind:SV_KEYPATH(self, image) toObjectAndKeyPathPairs:pairs withBlock:^id(SVMultibindArray *values) {
        // if remoteImage is nil, this value will also be nil (as opposed to a possible non-nil, but "0", value)
        if (values[0])
        {
            SVRemoteResourceState state = (SVRemoteResourceState)[values[0] intValue];
            
            if (state == SVRemoteResourceStateError)
            {
                return values[3]; // failure image
            }
            else
            {
                return values[1]; // remote scaled image
            }
        }
        else
        {
            return values[2]; // empty image
        }
    }];
    
    // bind content mode
    pairs = @[SVMultibindPair(self, SV_KEYPATH(self, remoteImage.state)),
              SVMultibindPair(self, SV_KEYPATH(self, imageContentMode)),
              SVMultibindPair(self, SV_KEYPATH(self, failureImageContentMode)),
              SVMultibindPair(self, SV_KEYPATH(self, emptyImageContentMode))];
    
    [self sv_multibind:SV_KEYPATH(self, contentMode) toObjectAndKeyPathPairs:pairs withBlock:^id(SVMultibindArray *values) {
        if (values[0]) // if the image view has a URL, check for error state
        {
            SVRemoteResourceState state = (SVRemoteResourceState)[values[0] intValue];
            return values[state == SVRemoteResourceStateError ? 2 : 1];
        }
        else // otherwise, use empty image content mode
        {
            return values[3];
        }
    }];
    
    // bind loading indicator
    [self sv_bind:SV_KEYPATH(self, activityIndicatorAnimating) toObject:self withKeyPath:SV_KEYPATH(self, remoteImage.state) block:^id(id value) {
        return @([value intValue] == SVRemoteResourceStateLoading);
    }];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self sharedInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self sharedInit];
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

#pragma mark - Activity Indicator View
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

-(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    return _activityIndicatorView.activityIndicatorViewStyle;
}

-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}

@end
