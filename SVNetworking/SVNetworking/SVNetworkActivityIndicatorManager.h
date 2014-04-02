//
//  SVNetworkActivityIndicatorManager.h
//  SVNetworking
//
//  Created by Nate Stedman on 4/1/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRequest.h"

/**
 Provides an implementation of the network activity indicator for requests.
 */
@interface SVNetworkActivityIndicatorManager : NSObject <SVRequestNetworkActivityIndicatorDelegate>

@end
