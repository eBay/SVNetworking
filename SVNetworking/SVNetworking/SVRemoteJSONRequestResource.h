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
 SVRemoteJSONRequest Resource is an abstract class of SVRemoteResource that loads a resource as JSON data over the
 network. Once loading is finished, subclasses must interpret that data to set their properties, or fail with an error.
 */
@interface SVRemoteJSONRequestResource : SVRemoteResource

#pragma mark - Implementation
/** @name Implementation */

/**
 After JSON loading is complete, this message will be passed. Subclasses generally will not need to override this
 message.
 
 If subclasses provide an alternative loading implementation in -beginLoading (i.e. from a disk cache), they should
 pass this message once the JSON has been loaded.
 
 @param JSON The loaded JSON.
 */
-(void)finishLoadingWithJSON:(id)JSON;

/**
 A convenience message for subclasses using a data-based alternative loading method (i.e. a disk cache). This message
 will parse the passed data and pass -finishLoadingWithJSON: or -failLoadingWithError: as is appropriate.
 
 @param JSONData A data object to be parsed as JSON.
 */
-(void)finishLoadingWithJSONData:(NSData*)JSONData;

#pragma mark - Subclass Implementation
/** @name Subclass Implementation */

/**
 Subclasses must override this message to provide a JSON request to load themselves.
 
 @warning The default implementation throws an exception.
 
 @returns A valid JSON request for loading this resource.
 */
-(SVJSONRequest*)requestForNetworkLoading;

/**
 Subclasses must override this message to parse loaded JSON (and set completion properties) or set the error pointer.
 
 @warning The default implementation throws an exception.
 
 @param JSON The JSON to parse.
 @param error An error out pointer, which should be set if the JSON is invalid.
 @returns `YES` for a successful parse, otherwise `NO`.
 */
-(BOOL)parseFinishedJSON:(id)JSON error:(__autoreleasing NSError**)error;

@end
