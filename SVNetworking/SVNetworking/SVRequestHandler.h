//
//  SVRequestHandler.h
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRequest.h"

typedef void(^SVRequestHandlerError)(NSError *error);

@interface SVRequestHandler : NSObject

#pragma mark - Initialization
/** @name Initialization */
/**
 *  Initializes a request handler.
 *
 *  @param request The request to handle.
 */
-(id)initWithRequest:(SVRequest*)request;

#pragma mark - Request
/** @name Request */
/**
 *  The request this handler is managing.
 */
@property (nonatomic, readonly, strong) SVRequest *request;

#pragma mark - Error Handling
/** @name Error Handling */
/**
 *  A block to run when the request fails.
 */
@property (nonatomic, copy) SVRequestHandlerError errorBlock;

#pragma mark - Subclass Implementation
/** @name Subclass Implementation */
/**
 *  Instructs subclasses to handle completion.
 *
 *  @param data     The loaded data.
 *  @param response The URL response.
 *  @param error    An error pointer to be used if returning `NO`.
 *
 *  @return `YES` if parsing was successful, otherwise `NO`.
 */
-(BOOL)handleCompletionWithData:(NSData*)data response:(NSURLResponse*)response error:(NSError**)error;

@end
