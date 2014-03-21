//
//  SVRemoteDataResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteDataRequestResource.h"

/**
 SVRemoteDataResource loads a chunk of data over the network, with a specified URL.
 
 If your data is an image, you should use SVRemoteImage (or one of the scaled variants). Additionally, you should
 consider using SVImageView - it probably does everything that you need.
 */
@interface SVRemoteDataResource : SVRemoteDataRequestResource

#pragma mark - Access
/**
 Returns an (in-memory) cached remote data for the specified URL.
 */
+(instancetype)cachedRemoteDataForURL:(NSURL*)URL;

/**
 Returns a remote data for the specified URL.
 */
+(instancetype)remoteDataForURL:(NSURL*)URL;

#pragma mark - URL
/**
 The URL to load data from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Data
/**
 The loaded data. This property is observable.
 */
@property (nonatomic, readonly, strong) NSData* data;

@end
