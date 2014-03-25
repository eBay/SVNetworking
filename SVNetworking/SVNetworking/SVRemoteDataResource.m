//
//  SVRemoteDataResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteDataResource.h"

@interface SVRemoteDataResource ()

#pragma mark - URL
@property (nonatomic, strong) NSURL *URL;

#pragma mark - Data
@property (nonatomic, strong) NSData* data;

@end

@implementation SVRemoteDataResource

#pragma mark - Access
+(instancetype)cachedRemoteDataForURL:(NSURL*)URL
{
    return [self cachedResourceWithUniqueKey:URL.absoluteString];
}

+(instancetype)remoteDataForURL:(NSURL*)URL
{
    return [self resourceWithUniqueKey:URL.absoluteString withInitializationBlock:^(SVRemoteDataResource *resource) {
        resource.URL = URL;
    }];
}

#pragma mark - Implementation - Network Loading
-(SVDataRequest*)requestForNetworkLoading
{
    return [SVDataRequest GETRequestWithURL:_URL];
}

-(BOOL)parseFinishedData:(NSData*)data error:(__autoreleasing NSError**)error
{
    self.data = data;
    return YES;
}

@end
