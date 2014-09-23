//
//  SVDataRequestHandler.h
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRequestHandler.h"

typedef void(^SVDataRequestHandlerCompletion)(NSData *data);

@interface SVDataRequestHandler : SVRequestHandler

/**
 *  The completion block to run on successful load.
 */
@property (nonatomic, copy) SVDataRequestHandlerCompletion completionBlock;

@end

typedef SVDataRequestHandler*(^SVDataRequestHandlerBuilder)(SVDataRequestHandlerCompletion completion, SVRequestHandlerError error);

@interface SVRequest (SVDataRequestHandler)

-(SVDataRequestHandlerBuilder)data;

@end
