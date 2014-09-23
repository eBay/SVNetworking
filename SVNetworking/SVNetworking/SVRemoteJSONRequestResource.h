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

#import "SVRemoteResource.h"
#import "SVJSONRequestHandler.h"

/**
 SVRemoteJSONRequest Resource is an abstract class of SVRemoteResource that loads a resource as JSON data over the
 network. Once loading is finished, subclasses must interpret that data to set their properties, or fail with an error.
 */
@interface SVRemoteJSONRequestResource : SVRemoteResource

#pragma mark - Implementation
/** @name Implementation */

/**
 After JSON loading is complete, this message will be passed. Subclasses generally will not need to override this
 message.
 
 If subclasses provide an alternative loading implementation in -beginLoading (i.e. from a disk cache), they should
 pass this message once the JSON has been loaded.
 
 @param JSON The loaded JSON.
 */
-(void)finishLoadingWithJSON:(id)JSON;

/**
 A convenience message for subclasses using a data-based alternative loading method (i.e. a disk cache). This message
 will parse the passed data and pass -finishLoadingWithJSON: or -failLoadingWithError: as is appropriate.
 
 Note that using this message will bypass any validation performed in a JSON request subclass.
 
 @param JSONData A data object to be parsed as JSON.
 */
-(void)finishLoadingWithJSONData:(NSData*)JSONData;

#pragma mark - Subclass Implementation
/** @name Subclass Implementation */

/**
 Subclasses must override this message to provide a JSON request to load themselves.
 
 @warning The default implementation throws an exception.
 
 @returns A valid JSON request for loading this resource.
 */
-(SVRequest*)requestForNetworkLoading;

/**
 Subclasses must override this message to parse loaded JSON (and set completion properties) or set the error pointer.
 
 @warning The default implementation throws an exception.
 
 @param JSON The JSON to parse.
 @param error An error out pointer, which should be set if the JSON is invalid.
 @returns `YES` for a successful parse, otherwise `NO`.
 */
-(BOOL)parseFinishedJSON:(id)JSON error:(__autoreleasing NSError**)error;

@end
