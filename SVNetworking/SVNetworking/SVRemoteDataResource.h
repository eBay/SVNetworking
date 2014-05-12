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

#import "SVRemoteDataRequestResource.h"

/**
 SVRemoteDataResource loads a chunk of data over the network, with a specified URL.
 
 If your data is an image, you should use SVRemoteImage (or one of the scaled variants). Additionally, you should
 consider using SVImageView - it probably does everything that you need.
 */
@interface SVRemoteDataResource : SVRemoteDataRequestResource

#pragma mark - Access
/** @name Access */

/**
 Returns an (in-memory) cached remote data for the specified URL.
 
 @param URL The URL to load data from.
 */
+(instancetype)cachedRemoteDataForURL:(NSURL*)URL;

/**
 Returns a remote data for the specified URL.
 
 @param URL The URL to load data from.
 */
+(instancetype)remoteDataForURL:(NSURL*)URL;

#pragma mark - URL
/** @name URL */

/**
 The URL to load data from.
 */
@property (nonatomic, readonly, strong) NSURL *URL;

#pragma mark - Data
/** @name Data */

/**
 The loaded data. This property is observable.
 */
@property (nonatomic, readonly, strong) NSData* data;

@end
