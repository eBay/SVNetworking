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

@interface SVRemoteJSONArray : SVRemoteArray

#pragma mark - Requests - Abstract
/**
 Subclasses must override this message (or override both -buildNextPageRequest and -buildRefreshRequest) to provide a
 default request object.
 
 The default implementation throws an exception.
 */
-(SVJSONRequest*)buildRequest;

#pragma mark - Requests
/**
 Allows subclasses to customize the next page request. The default implementation returns the result of -buildRequest.
 */
-(SVJSONRequest*)buildNextPageRequest;

/**
 Allows subclasses to customize the refresh request. The default implementation returns the result of -buildRequest.
 */
-(SVJSONRequest*)buildRefreshRequest;

#pragma mark - Parsing
/**
 Allow subclasses to find errors in JSON. If the JSON is valid, returns YES.
 
 The default implementation returns YES and does not set the error pointer.
 
 Note that for well-designed APIs, this can also be easily achieved with a subclass of SVJSONRequest, which should be
 much more reusable, and therefore is preferred.
 */
-(BOOL)checkJSON:(id)JSON error:(__autoreleasing NSError**)error;

#pragma mark - Parsing - Abstract
/**
 Subclasses must override this message to parse JSON data into items.
 */
-(NSArray*)itemsForJSON:(id)JSON withLoadingType:(SVRemoteJSONArrayLoadingType)loadingType;

/**
 Subclasses must override this message to determine if the array has an additional page.
 */
-(BOOL)hasNextPageForJSON:(id)JSON withParsedItems:(NSArray*)items;

@end
