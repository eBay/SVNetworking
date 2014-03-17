//
//  SVRemoteDataResource.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteResource.h"

@interface SVRemoteDataResource : SVRemoteResource

#pragma mark - Implementation
-(void)finishLoadingWithData:(NSData*)data;
-(void)parseFinishedData:(NSData*)data error:(NSError**)error;

@end
