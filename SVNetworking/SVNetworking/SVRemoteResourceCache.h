//
//  SVRemoteResourceCache.h
//  SVNetworking
//
//  Created by Nate Stedman on 4/1/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SVRemoteResourceCacheReadCompletionBlock)(NSData *data);
typedef void(^SVRemoteResourceCacheFailureBlock)(NSError *error);
typedef void(^SVRemoteResourceCacheWriteCompletionBlock)(void);

@class SVRemoteResource;

/**
 Defines messages for a data cache keyed by remote objects.
 
 For an in-memory cache, use NSCache to store actual remote resource instances.
 
 SVRemoteResourceDiskCache is an implementation of this protocol.
 */
@protocol SVRemoteResourceCache <NSObject>

#pragma mark - Reading
/** @name Reading */

/**
 Reads data from the cache.
 
 @param remoteResource The resource to read data for.
 @param completion A block to call after data is successfully loaded. The thread that this block should be called on is
 not specified. This parameter may be `nil`.
 @param failure A block to call if the cache does not contain data for the resource, or the data cannot be loaded. The
 thread that this block should be called on is not specified. This parameter may be `nil`.
 */
-(void)dataForResource:(SVRemoteResource*)remoteResource
            completion:(SVRemoteResourceCacheReadCompletionBlock)completion
               failure:(SVRemoteResourceCacheFailureBlock)failure;

#pragma mark - Writing
/** @name Writing */

/**
 Writes data to the cache.
 
 @param data The data to write.
 @param remoteResource The resource to key the data to.
 @param completion A block to call upon successful write. The thread that this block should be called on is not
 specified. This parameter may be `nil`.
 @param failure A block to call if the write fails. The thread that this block should be called on is not specified.
 This parameter may be `nil`.
 */
-(void)writeData:(NSData*)data
     forResource:(SVRemoteResource*)remoteResource
      completion:(SVRemoteResourceCacheWriteCompletionBlock)completion
         failure:(SVRemoteResourceCacheFailureBlock)failure;

@end
