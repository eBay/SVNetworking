//
//  SVRemoteJSONResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteJSONRequestResource.h"

@interface SVRemoteJSONResource : SVRemoteJSONRequestResource

#pragma mark - Access
/**
 Returns an (in-memory) cached remote JSON resource for the specified URL.
 */
+(instancetype)cachedRemoteJSONForURL:(NSURL*)URL;

/**
 Returns a remote JSON resource for the specified URL.
 */
+(instancetype)remoteJSONForURL:(NSURL*)URL;

#pragma mark - URL
/**
 The URL to load JSON from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Data
/**
 The loaded JSON object. This property is observable.
 */
@property (nonatomic, readonly, strong) id JSON;

@end
