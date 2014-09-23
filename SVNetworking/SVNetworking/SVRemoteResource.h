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

#import "SVRemoteResourceDiskCache.h"

/**
 Specifies the current loading state of the remote resource.
 */
typedef NS_ENUM(NSInteger, SVRemoteResourceState)
{
    /**
     The remote resource has not loaded.
     */
    SVRemoteResourceStateNotLoaded,
    
    /**
     The remote resource is loading.
     */
    SVRemoteResourceStateLoading,
    
    /**
     The remote resource attempted to load, but encountered an error.
     */
    SVRemoteResourceStateError,
    
    /**
     The remote resource has finished loading successfully.
     */
    SVRemoteResourceStateFinished
};

/**
 SVRemoteResource is an abstract class to load resources from a remote source, typically over the network.
 
 Instances are uniqued by class and a key string (which is hashed, so that it can be safely used as a filename
 for disk caches). A remote resource that is unloaded or has failed to load can be instructed to load itself by
 sending the -load message. Subclasses provide various properties that will be set on a successful load, the
 -error property of the base class is used to communicate failure. The -state property will automatically update
 as the loading process begins, completes, or fails.
 
 Strictly speaking, uniquing is entirely optional. However, SVNetworking encourages it, and the built-in resource
 subclasses are only accessible via uniqued instances. Despite this, remote resource subclasses are free to have mutable
 properties or public instance initializers. This is discouraged, especially mutability.
 
 Consumers of the class should use KVO or bindings to observe changes.
 
 This class does not provide any actual networking support (as the network is an implementation detail of subclasses,
 and this class could easily be adapated to various non-network uses (loading a large resource from disk asynchronously,
 for example). Abstract network implementations are provided for raw data and JSON by SVRemoteDataResource and
 SVRemoteJSONResource respectively. SVRemoteImage, a subclass of SVRemoteDataResource, provides an image loader
 implementation.
 */
@interface SVRemoteResource : NSObject

#pragma mark - Unique Resources
/** @name Unique Resources */

/**
 Retrieves a cached remote resource with the given unique key, if one exists. Otherwise, returns nil.
 
 Subclasses should provide their own accessors, as unique key generation for each remote resource subclass should be an
 implementation detail of that class, and not externally visible.
 
 @param uniqueKey The unique key of the resource to retrieve.
 @returns A retrieved resource of the reciever class with the specified unique key, or `nil`.
 */
+(instancetype)cachedResourceWithUniqueKey:(NSString*)uniqueKey;

/**
 Retrieves or creates a remote resource with the given unique key. This message must be sent to the resource subclass.
 
 If the resource is created, it will be passed to the initialization block (for ivar initialization). Otherwise, it
 will be simply returned.
 
 Subclasses should provide their own accessors, as unique key generation for each remote resource subclass should be an
 implementation detail of that class, and not externally visible.
 
 @param uniqueKey The unique key of the resource to retrieve or create.
 @param block An initialization block that will be passed if the resource is newly created.
 @returns A retrieved or newly created resource of the receiver class, with the specified unique key.
 */
+(instancetype)resourceWithUniqueKey:(NSString*)uniqueKey withInitializationBlock:(void(^)(id resource))block;

/**
 The hashed unique key for this remote resource. This key is safe to use as a filename for disk caching (and should 
 probably be used for that, in favor of anything else).
 */
@property (nonatomic, readonly) NSString *uniqueKeyHash;

#pragma mark - State
/** @name State */

/**
 The current loading state of the remote resource. This property is observable, and will automatically be updated
 throughout the loading process.
 */
@property (nonatomic, readonly) SVRemoteResourceState state;

#pragma mark - Error
/** @name Error */

/**
 The error that caused loading to fail.
 
 This property will be `nil` unless the current `state` value is `SVRemoteResourceStateError`. However, resources are
 not required to report an error when failing to load, so the value may still be `nil` even if the `state` value is
 `SVRemoteResourceStateError`.
 
 While all SVNetworking-provided resources attempt to provide proper error messages, this depends on the backing
 frameworks ability to do so. Also, non-built-in resources are not guaranteed to report an error message.
 
 @warning Do not use this property to determine failure state, use `state` directly.
 */
@property (nonatomic, readonly) NSError *error;

#pragma mark - Loading
/** @name Loading */

/**
 Instructs a remote resource to load itself, if it is not or has not already done so.
 
 Passing this message to a remote resource that has failed to load will clear the -error property and retry the loading
 process.
 */
-(void)load;

/**
 Passes -load to the resource, then returns the resource. Somewhat based on the style of -autorelease.
 
 Generally used to simplifying binding blocks from three lines to one.
 
 @returns The reciever.
 */
-(instancetype)autoload;

/**
 Instructs a remote resource to reload itself, even if it has already finished loading.
 
 Properties set by a completed resource will not be cleared to `nil` (or an equivalent 0 value) before reloading.
 
 Passing this message to a remote resource that has failed to load will clear the -error property and retry the loading
 process.
 
 This message has no effect on resources that are currently in the process of loading.
 */
-(void)reload;

#pragma mark - Implementation
/** Implementation */

/**
 Subclasses should pass this message to self when the loading process is complete. This will update the -state
 property to SVRemoteResourceStateFinished.
 */
-(void)finishLoading;

/**
 Subclasses should pass this message to self if the loading process fails. This will update the -state and -error
 properties.
 
 @param error The error that caused the failure. This parameter is optional - if `nil`, the resource's `state` will
 still be set to `SVRemoteResourceStateError`.
 */
-(void)failLoadingWithError:(NSError*)error;

#pragma mark - Subclass Implementation
/** Subclass Implementation */

/**
 Subclasses must override this message, to begin their loading implementation.
 
 The default implementation of this message throws an exception.
 */
-(void)beginLoading;

#pragma mark - Disk Cache
/** @name Disk Cache */

/**
 A disk cache for subclasses to store downloaded data in.
 */
+(SVRemoteResourceDiskCache*)diskCache;

@end
