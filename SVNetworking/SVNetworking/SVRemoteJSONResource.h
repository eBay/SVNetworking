//
//  SVRemoteJSONResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"
#import "SVJSONRequest.h"

/**
 SVRemoteJSONResource is an abstract class of SVRemoteResource that loads a resource as JSON data over the network.
 Once loading is finished, subclasses must interpret that data to set their properties, or fail with an error.
 */
@interface SVRemoteJSONResource : SVRemoteResource

#pragma mark - Implementation
/**
 After JSON loading is complete, this message will be passed. Subclasses generally will not need to override this
 message.
 
 If subclasses provide an alternative loading implementation in -beginLoading (i.e. from a disk cache), they should
 pass this message once the JSON has been loaded.
 */
-(void)finishLoadingWithJSON:(id)JSON;

#pragma mark - Subclass Implementation
/**
 Subclasses must override this message to provide a JSON request to load themselves.
 
 The default implementation throws an exception.
 */
-(SVJSONRequest*)requestForNetworkLoading;

/**
 Subclasses must override this message to parse loaded JSON (and set completion properties) or set the error pointer.
 
 The default implementation throws an exception.
 */
-(void)parseFinishedJSON:(id)JSON error:(NSError**)error;

@end