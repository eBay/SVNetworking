//
//  SVDataRequestHandler.m
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVDataRequestHandler.h"

@implementation SVDataRequestHandler

-(BOOL)handleCompletionWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *__autoreleasing *)error
{
    if (_completionBlock)
    {
        _completionBlock(data);
    }
    
    return YES;
}

@end

@implementation SVRequest (SVDataRequestHandler)

-(SVDataRequestHandlerBuilder)data
{
    return ^SVDataRequestHandler*(SVDataRequestHandlerCompletion completion, SVRequestHandlerError error) {
        // create a handler
        SVDataRequestHandler *handler = [[SVDataRequestHandler alloc] initWithRequest:self];
        
        // assign completion blocks
        handler.completionBlock = completion;
        handler.errorBlock = error;
        
        // start the request
        [handler.request start];
        
        return handler;
    };
}

@end
