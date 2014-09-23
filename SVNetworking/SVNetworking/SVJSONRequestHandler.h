//
//  SVJSONRequestHandler.h
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRequestHandler.h"

typedef void(^SVJSONRequestHandlerCompletion)(id JSON);

@interface SVJSONRequestHandler : SVRequestHandler

#pragma mark - Completion
/** @name Completion */
@property (nonatomic, copy) SVJSONRequestHandlerCompletion completionBlock;

#pragma mark - Parsing
/** @name Parsing */
/**
 Parses a data object into JSON objects.
 
 Subclasses can override this message to provide custom error checking at the handler level. For example, if your API
 specifies errors in a structured way (i.e. inside a `meta` object in JSON responses), you can check that, and report
 a request failure.
 
 @param data The data to parse.
 @param error An error pointer for parse failure.
 @returns A valid JSON object, or `nil`.
 */
-(id)parseJSONData:(NSData*)data error:(NSError**)error;

@end

typedef SVJSONRequestHandler*(^SVJSONRequestHandlerBuilder)(SVJSONRequestHandlerCompletion completion, SVRequestHandlerError error);

@interface SVRequest (SVJSONRequestHandler)

-(SVJSONRequestHandlerBuilder)JSON;

@end
