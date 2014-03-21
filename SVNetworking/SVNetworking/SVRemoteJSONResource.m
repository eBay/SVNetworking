//
//  SVRemoteJSONResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/17/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVRemoteJSONResource.h"

@interface SVRemoteJSONResource ()

#pragma mark - URL
@property (nonatomic, strong) NSURL *URL;

#pragma mark - JSON
@property (nonatomic, strong) id JSON;

@end

@implementation SVRemoteJSONResource

#pragma mark - Access
+(instancetype)cachedRemoteJSONForURL:(NSURL *)URL
{
    return [self cachedResourceWithUniqueKey:URL.absoluteString];
}

+(instancetype)remoteJSONForURL:(NSURL *)URL
{
    return [self resourceWithUniqueKey:URL.absoluteString withInitializationBlock:^(SVRemoteJSONResource *resource) {
        resource.URL = URL;
    }];
}

#pragma mark - Implementation - Network Loading
-(SVJSONRequest*)requestForNetworkLoading
{
    return [SVJSONRequest GETRequestWithURL:_URL];
}

-(BOOL)parseFinishedJSON:(id)JSON error:(NSError *__autoreleasing *)error
{
    self.JSON = JSON;
    return YES;
}

@end
