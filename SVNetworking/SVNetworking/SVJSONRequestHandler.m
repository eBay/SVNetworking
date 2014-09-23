//
//  SVJSONRequestHandler.m
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVJSONRequestHandler.h"

@implementation SVJSONRequestHandler

#pragma mark - Parsing
-(BOOL)handleCompletionWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *__autoreleasing *)error
{
    id JSON = [self parseJSONData:data error:error];
    
    if (JSON)
    {
        if (_completionBlock)
        {
            _completionBlock(JSON);
        }
    }
    
    return JSON != nil;
}

-(id)parseJSONData:(NSData*)data error:(NSError*__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

@end

@implementation SVRequest (SVJSONRequestHandler)

-(SVJSONRequestHandlerBuilder)JSON
{
    return ^SVJSONRequestHandler*(SVJSONRequestHandlerCompletion completion, SVRequestHandlerError error) {
        // create a handler
        SVJSONRequestHandler *handler = [[SVJSONRequestHandler alloc] initWithRequest:self];
        
        // assign completion blocks
        handler.completionBlock = completion;
        handler.errorBlock = error;
        
        // start the request
        [handler.request start];
        
        return handler;
    };
}

@end

