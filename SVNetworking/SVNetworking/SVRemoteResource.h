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

/**
 SVRemoteResource is an abstract class to load resources from a remote source, typically over the network.
 
 Instances are uniqued by class and a key string (which is hashed, so that it can be safely used as a filename
 for disk caches). A remote resource that is unloaded or has failed to load can be instructed to load itself by
 sending the -load message. Subclasses provide various properties that will be set on a successful load, the
 -error property of the base class is used to communicate failure. The -state property will automatically update
 as the loading process begins, completes, or fails.
 
 Consumers of the class should use KVO or bindings to observe changes.
 
 This class does not provide any actual networking support (as the network is an implementation detail of subclasses,
 and this class could easily be adapated to various non-network uses (loading a large resource from disk asynchronously,
 for example). Abstract network implementations are provided for raw data and JSON by SVRemoteDataResource and
 SVRemoteJSONResource respectively. SVRemoteImage, a subclass of SVRemoteDataResource, provides an image loader
 implementation.
 */
@interface SVRemoteResource : NSObject

#pragma mark - Unique Resources
/**
 Retrieves a cached remote resource with the given unique key, if one exists. Otherwise, returns nil.
 
 Subclasses should provide their own accessors, as unique key generation for each remote resource subclass should be an
 implementation detail of that class, and not externally visible.
 */
+(instancetype)cachedResourceWithUniqueKey:(NSString*)uniqueKey;

/**
 Retrieves or creates a remote resource with the given unique key. This message must be sent to the resource subclass.
 
 If the resource is created, it will be passed to the initialization block (for ivar initialization). Otherwise, it
 will be simply returned.
 
 Subclasses should provide their own accessors, as unique key generation for each remote resource subclass should be an
 implementation detail of that class, and not externally visible.
 */
+(instancetype)resourceWithUniqueKey:(NSString*)uniqueKey withInitializationBlock:(void(^)(id resource))block;

/**
 The hashed unique key for this remote resource. This key is safe to use as a filename for disk caching (and should 
 probably be used for that, in favor of anything else).
 */
@property (nonatomic, readonly) NSString *uniqueKeyHash;

#pragma mark - State
/**
 The current loading state of the remote resource. This property is observable, and will automatically be updated
 throughout the loading process.
 */
@property (nonatomic, readonly) SVRemoteResourceState state;

#pragma mark - Error
/**
 If the current state is SVRemoteResourceError, the error that caused the failure. Otherwise, nil. This property is
 observable.
 */
@property (nonatomic, readonly) NSError *error;

#pragma mark - Loading
/**
 Instructs a remote resource to load itself, if it is not or has not already done so.
 
 Passing this message to a remote resource that has failed to load will clear the -error property and retry the loading
 process.
 */
-(void)load;

/**
 Passes -load to the resource, then returns the resource. Somewhat based on the style of -autorelease.
 
 Generally used to simplifying binding blocks from three lines to one.
 */
-(instancetype)autoload;

#pragma mark - Implementation
/**
 Subclasses should pass this message to self when the loading process is complete. This will update the -state
 property to SVRemoteResourceStateFinished.
 */
-(void)finishLoading;

/**
 Subclasses should pass this message to self if the loading process fails. This will update the -state and -error
 properties.
 */
-(void)failLoadingWithError:(NSError*)error;

#pragma mark - Subclass Implementation
/**
 Subclasses must override this message, to begin their loading implementation.
 
 The default implementation of this message throws an exception.
 */
-(void)beginLoading;

@end
