//
//  SVRemoteScaledImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVRemoteRetainedProxyResource.h"
#import "SVRemoteScaledImageProtocol.h"

/**
 SVRemoteScaledImage loads an image over the network from a URL, and scales it to fit within the specified size.
 
 Observe the -image property with KVO or bindings.
 
 Internally, the class proxies SVRemoteImage, so images are cached to disk once loaded, and will be loaded from the
 cache if available.
 */
@interface SVRemoteScaledImage : SVRemoteRetainedProxyResource <SVRemoteScaledImageProtocol>

@end
