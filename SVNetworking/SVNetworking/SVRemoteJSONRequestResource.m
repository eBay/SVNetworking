/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SVRemoteJSONRequestResource.h"

@interface SVRemoteJSONRequestResource () <SVJSONRequestDelegate>
{
@private
    SVJSONRequest *_request;
}

@end

@implementation SVRemoteJSONRequestResource

#pragma mark - JSON Request Delegate
-(void)request:(SVDataRequest *)request finishedWithJSON:(id)JSON response:(NSHTTPURLResponse *)response
{
    _request = nil;
    [self finishLoadingWithJSON:JSON];
}

-(void)request:(SVRequest *)request failedWithError:(NSError *)error
{
    _request = nil;
    [self failLoadingWithError:error];
}

#pragma mark - Implementation
-(void)beginLoading
{
    // send loading request
    _request = [self requestForNetworkLoading];
    _request.delegate = self;
    [_request start];
}

-(void)finishLoadingWithJSON:(id)JSON
{
    NSError *error = nil;
    BOOL success = [self parseFinishedJSON:JSON error:&error];
    
    if (success)
    {
        [self finishLoading];
    }
    else
    {
        [self failLoadingWithError:error];
    }
}

-(void)finishLoadingWithJSONData:(NSData*)JSONData
{
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (JSON)
    {
        [self finishLoadingWithJSON:JSON];
    }
    else
    {
        [self failLoadingWithError:error];
    }
}

#pragma mark - Subclass Implementation
-(SVJSONRequest*)requestForNetworkLoading
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(BOOL)parseFinishedJSON:(id)JSON error:(NSError *__autoreleasing *)error
{
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

@end
