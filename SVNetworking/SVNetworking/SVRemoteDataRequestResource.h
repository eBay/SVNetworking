//
//  SVRemoteDataResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"

/**
 SVRemoteDataRequestResource is an abstract class of SVRemoteResource that loads a resource as raw data over the
 network. Once loading is finished, subclasses must interpret that data to set their properties, or fail with an error.
 */
@interface SVRemoteDataRequestResource : SVRemoteResource

#pragma mark - Implementation
/** @name Implementation */

/**
 After data loading is complete, this message will be passed. Subclasses generally will not need to override this
 message.
 
 If subclasses provide an alternative loading implementation in -beginLoading (i.e. from a disk cache), they should
 pass this message once the data has been loaded.
 
 @param data The data that the resource has loaded.
 */
-(void)finishLoadingWithData:(NSData*)data;

#pragma mark - Subclass Implementation
/** @name Subclass Implementation */

/**
 Subclasses must override this message to provide a data request to load themselves.
 
 @warning The default implementation throws an exception.
 
 @returns A valid data request for loading this resource.
 */
-(SVDataRequest*)requestForNetworkLoading;

/**
 Subclasses must override this message to parse loaded data (and set completion properties) or set the error pointer.
 
 @warning The default implementation throws an exception.
 
 @param data The data to parse.
 @param error An error out pointer, which should be set if the data is invalid.
 @returns `YES` for a successful parse, otherwise `NO`.
 */
-(BOOL)parseFinishedData:(NSData*)data error:(__autoreleasing NSError**)error;

@end
