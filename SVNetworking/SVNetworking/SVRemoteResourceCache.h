//
//  SVRemoteResourceCache.h
//  SVNetworking
//
//  Created by Nate Stedman on 4/1/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Defines messages for a cached keyed by remote objects.
 */
@protocol SVRemoteResourceCache <NSObject>

#pragma mark - Reading
/** @name Reading */
-(void)dataForKey:(NSString*)key completion:(void(^)(NSData *data))completion failure:(void(^)(NSError *error))failure;

#pragma mark - Writing
/** @name Writing */
-(void)writeData:(NSData*)data forKey:(NSString*)key completion:(void(^)())completion failure:(void(^)(NSError *error))failure;

@end
