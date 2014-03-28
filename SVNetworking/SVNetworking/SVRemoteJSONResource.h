//
//  SVRemoteJSONResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteJSONRequestResource.h"

/**
 SVRemoteJSONResource loads JSON data over the network, and, once complete, provides it via an observable property.
 */
@interface SVRemoteJSONResource : SVRemoteJSONRequestResource

#pragma mark - Access
/** @name Access */

/**
 Returns an (in-memory) cached remote JSON resource for the specified URL.
 
 @param URL The URL for the JSON resource.
 */
+(instancetype)cachedRemoteJSONForURL:(NSURL*)URL;

/**
 Returns a remote JSON resource for the specified URL.
 
 @param URL The URL for the JSON resource.
 */
+(instancetype)remoteJSONForURL:(NSURL*)URL;

#pragma mark - URL
/** @name URL */

/**
 The URL to load JSON from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Data
/** @name Data */

/**
 The loaded JSON object. This property is observable.
 */
@property (nonatomic, readonly, strong) id JSON;

@end
