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
-(void)remoteArray:(SVRemoteArray*)remoteArray didLoadNextPageWithItems:(NSArray*)items hasNextPage:(BOOL)hasNextPage;

// error handling
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToRefreshWithError:(NSError*)error;
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToLoadNextPageWithError:(NSError*)error;

@end

@interface SVRemoteArray : NSObject

#pragma mark - Contents
/**
 The current contents of the remote array.
 
 This property is observable.
 */
@property (nonatomic, readonly, strong) NSArray *contents;

#pragma mark - Element Access
/**
 Returns the object at the specified index in the array.
 
 This is a convenience passthrough to the "contents" array.
 */
-(id)objectAtIndexedSubscript:(NSUInteger)index;

/**
 Returns the number of objects in the array.
 
 This is a convenience passthrough to the "contents" array.
 
 This property is observable.
 */
@property (nonatomic, readonly) NSUInteger count;

#pragma mark - Loading Instructions
/**
 Instructs the array to load its next page. This will only be performed if it makes sense (i.e. there is a next page,
 and the array isn't already loading it).
 */
-(void)loadNextPage;

/**
 Instructs the array to refresh its contents. This will only be performed if it makes sense (i.e. the array has already
 loaded its first page, the array is refreshable, and the array is not already refreshing).
 */
-(void)refresh;

#pragma mark - Loading State
/**
 Returns YES if the array is currently loading its next page.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL isLoadingNextPage;

/**
 Returns YES if the array is currently refreshing.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL isRefreshing;

/**
 Returns YES if the array has a next page to load.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL hasNextPage;

#pragma mark - Refreshability
/**
 Subclasses should override to return NO if the remote array is not refreshable.
 */
-(BOOL)refreshable;

#pragma mark - Loading Errors
/**
 The error that was encountered while failing to load the next page, or nil if an error was not encountered. This
 property will be cleared to nil when -loadNextPage is sent to the array.
 
 This property is observable.
 */
@property (nonatomic, readonly, strong) NSError *nextPageError;

/**
 The error that was encountered while failing to refresh the array, or nil if an error was not encountered. This
 property will be cleared to nil when -refresh is sent to the array.
 
 This property is observable.
 */
@property (nonatomic, readonly, strong) NSError *refreshError;

#pragma mark - Pagination Observers
/**
 Adds a pagination observer to the array.
 
 Pagination observers are stored as weak references.
 */
-(void)addPaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;

/**
 Removes a pagination observer from the array.
 */
-(void)removePaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;

/**
 Passes each pagination observer currently attached to the array to the block.
 */
-(void)enumeratePaginationObservers:(void(^)(id<SVRemoteArrayPaginationObserver> paginationObserver))block;

#pragma mark - Implementation - Abstract (Subclasses)
/**
 Subclasses must override this message to provide a loading implementation for the next page.
 */
-(void)beginLoadingNextPage;

/**
 Subclasses may override this message to provide a refresh implementation.
 
 If a refresh implementation is not provided, subclasses should override -refreshable to return NO.
 */
-(void)beginRefreshing;

#pragma mark - Implementation - Next Page
/**
 Subclasses should pass this message to themselves once they have successfully finished loading data for the next page
 of the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 */
-(void)finishLoadingNextPageWithItems:(NSArray*)items hasNextPage:(BOOL)hasNextPage;

/**
 Subclasses should pass this message to themselves if they fail to load data for the next page of the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 */
-(void)failLoadingNextPageWithError:(NSError*)error;

#pragma mark - Implementation - Refresh
/**
 Subclasses should pass this message to themselves once they have successfully finished loading data for refreshing the
 remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 */
-(void)finishRefreshingWithItems:(NSArray*)items;

/**
 Subclasses should pass this message to themselves if they fail to load data for refreshing the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 */
-(void)failRefreshingWithError:(NSError*)error;

@end
