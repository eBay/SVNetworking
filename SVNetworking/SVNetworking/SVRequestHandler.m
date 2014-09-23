//
//  SVRequestHandler.m
//  SVNetworking
//
//  Created by Nate Stedman on 9/23/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRequestHandler.h"

@interface SVRequestHandler () <SVRequestDelegate>

@end

@implementation SVRequestHandler

-(id)initWithRequest:(SVRequest*)request
{
    self = [self init];
    
    if (self)
    {
        _request = request;
        _request.delegate = self;
    }
    
    return self;
}

#pragma mark - Request Delegate
-(void)request:(SVRequest *)request finishedWithResponse:(NSURLResponse *)response data:(NSData *)data
{
    NSError *error = nil;
    
    if (![self handleCompletionWithData:data response:response error:&error])
    {
        if (_errorBlock)
        {
            _errorBlock(error);
        }
    }
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    if (_errorBlock)
    {
        _errorBlock(error);
    }
}

#pragma mark - Subclass Implementation
-(BOOL)handleCompletionWithData:(NSData*)data response:(NSURLResponse*)response error:(NSError**)error
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end
