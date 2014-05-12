/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSObject+SVBindings.h"
#import "SVRemoteScaledImage.h"
#import "SVRemoteRetainedScaledImage.h"
#import "SVImageView.h"

@interface SVImageView ()
{
@private
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic, strong) UIImage *image;
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
    
    // add image view
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
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
    
    [_imageView sv_multibind:SV_KEYPATH(_imageView, contentMode) toObjectAndKeyPathPairs:pairs withBlock:^id(SVMultibindArray *values) {
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
    [self sv_unbindAll];
    [_imageView sv_unbindAll];
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

#pragma mark - Image
-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
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
