#import "SVRequest.h"

@class SVJSONRequest;

/**
 A delegate protocol for SVJSONRequest objects.
 */
@protocol SVJSONRequestDelegate <SVRequestDelegate>

/**
 Sent when the request finishes successfully.
 
 @param request The request.
 @param JSON The JSON loaded by the request.
 @param response The HTTP response received by the request.
 */
-(void)request:(SVRequest*)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse*)response;

@end

/**
 A request that loads JSON objects.
 */
@interface SVJSONRequest : SVRequest

/** @name Delegation */
/**
 The delegate for the request. */
@property (readwrite, weak) id<SVJSONRequestDelegate> delegate;

/** @name Parsing */
/**
 Parses a data object into JSON objects.
 
 Subclasses can override this message to provide custom error checking at the request level. For example, if your API
 specifies errors in a structured way (i.e. inside a `meta` object in JSON responses), you can check that, and report
 a request failure.
 
 @param data The data to parse.
 @param error An error pointer for parse failure.
 @returns A valid JSON object, or `nil`.
 */
-(id)parseJSONData:(NSData*)data error:(__autoreleasing NSError**)error;

@end
