//
//  ILERemoteImageView.h
//  ImageLoadingExample
//
//  Created by Nate Stedman on 3/18/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <SVNetworking/SVNetworking.h>

@interface ILERemoteImageView : UIImageView

@property (nonatomic, strong) SVRemoteResource<SVRemoteImageProtocol>* remoteImage;

@end
