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

/**
 Defines messages for a cached keyed by remote objects.
 */
@protocol SVRemoteResourceCache <NSObject>

#pragma mark - Reading
/** @name Reading */
-(void)dataForKey:(NSString*)key
       completion:(SVRemoteResourceCacheReadCompletionBlock)completion
          failure:(SVRemoteResourceCacheFailureBlock)failure;

#pragma mark - Writing
/** @name Writing */
-(void)writeData:(NSData*)data
          forKey:(NSString*)key
      completion:(SVRemoteResourceCacheWriteCompletionBlock)completion
         failure:(SVRemoteResourceCacheFailureBlock)failure;

@end
