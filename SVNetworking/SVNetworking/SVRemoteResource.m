//
//  SVRemoteResource.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/14/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "SVRemoteResource.h"

@interface SVRemoteResource ()

#pragma mark - State
@property (nonatomic) SVRemoteResourceState state;

#pragma mark - Error
@property (nonatomic) NSError *error;

@end

@implementation SVRemoteResource

#pragma mark - Unique Resources
+(instancetype)resourceWithKey:(NSString*)key withInitializationBlock:(void(^)(id resource))block;
{
    static NSMapTable *resourceTable;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        resourceTable = [NSMapTable strongToWeakObjectsMapTable];
    });
    
    SVRemoteResource *resource = [resourceTable objectForKey:key];
    
    if (!resource)
    {
        resource = [self new];
        
        if (resource)
        {
            resource->_key = key;
            
            if (block)
            {
                block(resource);
            }
            
            [resourceTable setObject:resource forKey:key];
        }
    }
    
    return resource;
}

+(NSString*)keyForString:(NSString *)string
{
    // why we're not using NSString hash -> https://gist.github.com/fphilipe/3413755
    // note that the class name is prefixed
    
    const char* str = string.UTF8String;
    unsigned char result[16];
    CC_MD5(str, (unsigned int)strlen(str), result);
    return [NSString stringWithFormat:@"%@%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            self,
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

#pragma mark - Loading
-(void)load
{
    if (_state == SVRemoteResourceStateNotLoaded || _state == SVRemoteResourceStateError)
    {
        // update state
        self.state = SVRemoteResourceStateLoading;
        
        // custom or network loading
        [self beginLoading];
    }
}

#pragma mark - Implementation - Custom Load
-(void)beginLoading
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void)finishLoading
{
    self.state = SVRemoteResourceStateFinished;
}

-(void)finishLoadingWithError:(NSError *)error
{
    self.error = error;
    self.state = SVRemoteResourceStateError;
}

@end
