//
//  SVRemoteArray.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/27/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SVRemoteArray;

@protocol SVRemoteArrayPaginationObserver <NSObject>

@optional

// page loading
-(void)remoteArray:(SVRemoteArray*)remoteArray didRefreshWithItems:(NSArray*)items;
-(void)remoteArray:(SVRemoteArray*)remoteArray didLoadNextPageWithItems:(NSArray*)items;

// error handling
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToRefreshWithError:(NSError*)error;
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToLoadNextPageWithError:(NSError*)error;

@end

@interface SVRemoteArray : NSObject

#pragma mark - Pagination Observers
-(void)addPaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;
-(void)removePaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;
-(void)enumeratePaginationObservers:(void(^)(id<SVRemoteArrayPaginationObserver> paginationObserver))block;

@end
