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
 Defines messages for a cached keyed by remote objects.
 */
@protocol SVRemoteResourceCache <NSObject>

#pragma mark - Reading
/** @name Reading */
-(void)dataForResource:(SVRemoteResource*)remoteResource
            completion:(SVRemoteResourceCacheReadCompletionBlock)completion
               failure:(SVRemoteResourceCacheFailureBlock)failure;

#pragma mark - Writing
/** @name Writing */
-(void)writeData:(NSData*)data
     forResource:(SVRemoteResource*)remoteResource
      completion:(SVRemoteResourceCacheWriteCompletionBlock)completion
         failure:(SVRemoteResourceCacheFailureBlock)failure;

@end
