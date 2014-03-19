//
//  SVRemoteScaledImage.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteProxyResource.h"
#import "SVRemoteScaledImageProtocol.h"

/**
 SVRemoteScaledImage loads an image over the network from a URL, and scales it to fit within the specified size.
 
 Observe the -image property with KVO or bindings.
 
 Internally, the class proxies SVRemoteImage, so images are cached to disk once loaded, and will be loaded from the
 cache if available. The fully-sized scaled image is dynamically acquired when needed, and released after loading
 finishes. To retain the fully-sized image for the lifetime of the proxy instance, use SVRemoteRetainedScaledImage.
 */
@interface SVRemoteScaledImage : SVRemoteProxyResource <SVRemoteScaledImageProtocol>

@end
