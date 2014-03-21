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
/**
 After data loading is complete, this message will be passed. Subclasses generally will not need to override this
 message.
 
 If subclasses provide an alternative loading implementation in -beginLoading (i.e. from a disk cache), they should
 pass this message once the data has been loaded.
 */
-(void)finishLoadingWithData:(NSData*)data;

#pragma mark - Subclass Implementation
/**
 Subclasses must override this message to provide a data request to load themselves.
 
 The default implementation throws an exception.
 */
-(SVDataRequest*)requestForNetworkLoading;

/**
 Subclasses must override this message to parse loaded data (and set completion properties) or set the error pointer.
 
 The default implementation throws an exception.
 */
-(BOOL)parseFinishedData:(NSData*)data error:(NSError**)error;

@end
