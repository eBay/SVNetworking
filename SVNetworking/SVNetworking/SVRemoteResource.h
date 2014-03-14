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
+(instancetype)resourceWithKey:(NSString*)key withInitializationBlock:(void(^)(id resource))block;
+(NSString*)keyForString:(NSString*)string;

#pragma mark - State
@property (nonatomic, readonly) SVRemoteResourceState state;

#pragma mark - Error
@property (nonatomic, readonly) NSError *error;

#pragma mark - Loading
-(void)load;

#pragma mark - Implementation - Custom Loading
-(void)beginLoading;
-(void)finishLoadingWithData:(NSData*)data;
-(void)finishLoadingWithError:(NSError*)error;

#pragma mark - Implementation - Network Loading
-(SVDataRequest*)requestForNetworkLoading;

#pragma mark - Implementation - Shared
-(void)finishWithData:(NSData*)data error:(NSError**)error;

@end
