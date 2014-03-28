//
//  SVRemoteJSONArray.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/27/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVJSONRequest.h"
#import "SVRemoteArray.h"

typedef enum
{
    SVRemoteJSONArrayLoadingTypeRefresh,
    SVRemoteJSONArrayLoadingTypeNextPage
} SVRemoteJSONArrayLoadingType;

/**
 An abstract implementation of a remote array, using JSON requests to load its data.
 */
@interface SVRemoteJSONArray : SVRemoteArray

#pragma mark - Requests
/** @name Requests */

/**
 Allows subclasses to customize the next page request. The default implementation returns the result of -buildRequest.
 */
-(SVJSONRequest*)buildNextPageRequest;

/**
 Allows subclasses to customize the refresh request. The default implementation returns the result of -buildRequest.
 */
-(SVJSONRequest*)buildRefreshRequest;

#pragma mark - Requests - Abstract
/** @name Requests - Abstract */

/**
 Subclasses must override this message (or override both -buildNextPageRequest and -buildRefreshRequest) to provide a
 default request object.
 
 The default implementation throws an exception.
 */
-(SVJSONRequest*)buildRequest;

#pragma mark - Parsing
/** @name Parsing */

/**
 Allow subclasses to find errors in JSON. If the JSON is valid, returns YES.
 
 The default implementation returns YES and does not set the error pointer.
 
 Note that for well-designed APIs, this can also be easily achieved with a subclass of SVJSONRequest, which should be
 much more reusable, and therefore is preferred.
 
 @param JSON The JSON object to validate.
 @param error An error pointer to set if the JSON is invalid.
 @returns `YES` for valid JSON, otherwise `NO`.
 */
-(BOOL)checkJSON:(id)JSON error:(__autoreleasing NSError**)error;

#pragma mark - Parsing - Abstract
/** @name Parsing - Abstract */

/**
 Subclasses must override this message to parse JSON data into items.
 
 @param JSON The JSON object loaded for this page (or refresh).
 @param loadingType If this is a refresh or next page operation.
 @returns An array of parsed objects. If there is possible overlap with previously loaded items, it is the
 responsibility of the subclass to trim this array appropriately.
 */
-(NSArray*)itemsForJSON:(id)JSON withLoadingType:(SVRemoteJSONArrayLoadingType)loadingType;

/**
 Subclasses must override this message to determine if the array has an additional page.
 
 @param JSON The JSON object loaded for this page.
 @param items The parsed items for this page.
 @returns `YES` if the remote array has an additional page, otherwise `NO`.
 */
-(BOOL)hasNextPageForJSON:(id)JSON withParsedItems:(NSArray*)items;

@end
