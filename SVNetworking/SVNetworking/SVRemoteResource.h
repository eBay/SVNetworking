//
//  SVRemoteResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVDataRequest.h"

typedef enum {
    SVRemoteResourceStateNotLoaded,
    SVRemoteResourceStateLoading,
    SVRemoteResourceStateError,
    SVRemoteResourceStateFinished
} SVRemoteResourceState;

@interface SVRemoteResource : NSObject

#pragma mark - Unique Resources
+(instancetype)cachedResourceWithUniqueKey:(NSString*)uniqueKey;
+(instancetype)resourceWithUniqueKey:(NSString*)uniqueKey withInitializationBlock:(void(^)(id resource))block;
+(NSString*)uniqueKeyForString:(NSString*)string;

@property (nonatomic, readonly) NSString *uniqueKey;

#pragma mark - State
@property (nonatomic, readonly) SVRemoteResourceState state;

#pragma mark - Error
@property (nonatomic, readonly) NSError *error;

#pragma mark - Loading
-(void)load;

#pragma mark - Implementation - Custom Loading
-(void)beginLoading;
-(void)finishLoading;
-(void)failLoadingWithError:(NSError*)error;

@end
