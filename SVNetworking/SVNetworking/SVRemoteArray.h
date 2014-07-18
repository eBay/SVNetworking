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

#import <Foundation/Foundation.h>

@class SVRemoteArray;

/**
 Expresses the current loading state for the remote array's two ends.
 */
typedef NS_ENUM(NSInteger, SVRemoteArrayLoadingState)
{
    /**
     The remote array is not loading.
     */
    SVRemoteArrayLoadingStateNotLoading,
    
    /**
     The remote array attempted to load, but encountered an error.
     */
    SVRemoteArrayLoadingStateError,
    
    /**
     The remote array is loading.
     */
    SVRemoteArrayLoadingStateLoading
};

/**
 An observer for remote array page loading.
 
 This protocol is ideal for implementing a table view or collection view.
 */
@protocol SVRemoteArrayPaginationObserver <NSObject>

@optional

#pragma mark - Load Start
/** @name Load Start */

/**
 Notifies the receiver that the remote array will begin to refresh.
 
 @param remoteArray The remote array.
 */
-(void)remoteArrayWillBeginRefreshing:(SVRemoteArray*)remoteArray;

/**
 Notifies the receiver that the remote array will begin to load the next page.
 
 @param remoteArray The remote array.
 */
-(void)remoteArrayWillBeginLoadingNextPage:(SVRemoteArray*)remoteArray;

#pragma mark - Load Success
/** @name Load Success */
/**
 Sent when a remote array finishes refreshing.
 
 @param remoteArray The remote array.
 @param items The newly loaded items, which are at the front of the array.
 */
-(void)remoteArray:(SVRemoteArray*)remoteArray didRefreshWithItems:(NSArray*)items;

/**
 Sent when a remote array finishes loading its next page.
 
 @param remoteArray The remote array.
 @param items The newly loaded items, which are at the end of the array.
 @param hasNextPage `YES` if the remote array has a next page, otherwise `NO`.
 */
-(void)remoteArray:(SVRemoteArray*)remoteArray didLoadNextPageWithItems:(NSArray*)items hasNextPage:(BOOL)hasNextPage;

#pragma mark - Error Handling
/** @name Error Handling */
/**
 Sent when a remote array fails to refresh.
 
 @param remoteArray The remote array.
 @param error The error that caused the remote array to fail to refresh. This parameter may be `nil`.
 */
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToRefreshWithError:(NSError*)error;

/**
 Sent when a remote array fails to load its next page.
 
 @param remoteArray The remote array.
 @param error The error that caused the remote array to fail to load its next page. This parameter may be `nil`.
 */
-(void)remoteArray:(SVRemoteArray*)remoteArray didFailToLoadNextPageWithError:(NSError*)error;

@end

/**
 This class provides a base implementation of an ordered, paginated collection of objects, loaded from a remote source.
 */ 
@interface SVRemoteArray : NSObject <NSFastEnumeration>

#pragma mark - Contents
/** @name Contents */

/**
 The current contents of the remote array.
 
 This property is observable.
 */
@property (nonatomic, readonly, strong) NSArray *contents;

#pragma mark - Element Access
/** @name Element Access */

/**
 Returns the object at the specified index in the array.
 
 This is a convenience passthrough to the "contents" array.
 
 @param index The index.
 */
-(id)objectAtIndexedSubscript:(NSUInteger)index;

/**
 Returns the number of objects in the array.
 
 This is a convenience passthrough to the "contents" array.
 
 This property is observable.
 */
@property (nonatomic, readonly) NSUInteger count;

#pragma mark - Loading Instructions
/** @name Loading Instructions */

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
/** @name Loading State */

/**
 Returns YES if the array is currently loading its next page.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL isLoadingNextPage;

/**
 The current next page loading state.
 
 This property is observable.
 */
@property (nonatomic, readonly) SVRemoteArrayLoadingState nextPageLoadingState;

/**
 Returns YES if the array is currently refreshing.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL isRefreshing;

/**
 The current refresh loading state.
 
 This property is observable.
 */
@property (nonatomic, readonly) SVRemoteArrayLoadingState refreshLoadingState;

/**
 Returns YES if the array has a next page to load.
 
 This property is observable.
 */
@property (nonatomic, readonly) BOOL hasNextPage;

#pragma mark - Refreshability
/** @name Refreshability */

/**
 Subclasses should override to return NO if the remote array is not refreshable.
 */
-(BOOL)refreshable;

#pragma mark - Loading Errors
/** @name Loading Errors */

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
/** @name Pagination Observers */

/**
 Adds a pagination observer to the array.
 
 Pagination observers are stored as weak references.
 
 @param paginationObserver The pagination observer to add.
 */
-(void)addPaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;

/**
 Removes a pagination observer from the array.
 
 @param paginationObserver The pagination observer to remove.
 */
-(void)removePaginationObserver:(id<SVRemoteArrayPaginationObserver>)paginationObserver;

/**
 Passes each pagination observer currently attached to the array to the block.
 
 @param block The block to pass each pagination observer to.
 */
-(void)enumeratePaginationObservers:(void(^)(id<SVRemoteArrayPaginationObserver> paginationObserver))block;

#pragma mark - Implementation - Abstract (Subclasses)
/** @name Implementation - Abstract (Subclasses) */

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
/** @name Implementation - Next Page */

/**
 Subclasses should pass this message to themselves once they have successfully finished loading data for the next page
 of the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 
 @param items The items to append to the remote array.
 @param hasNextPage `YES` if the remote array has an additional page after this one, otherwise `NO`.
 */
-(void)finishLoadingNextPageWithItems:(NSArray*)items hasNextPage:(BOOL)hasNextPage;

/**
 Subclasses should pass this message to themselves if they fail to load data for the next page of the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 
 @param error The error that caused the failure. This parameter is optional.
 */
-(void)failLoadingNextPageWithError:(NSError*)error;

#pragma mark - Implementation - Refresh
/** @name Implementation - Refresh */

/**
 Subclasses should pass this message to themselves once they have successfully finished loading data for refreshing the
 remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 
 @param items The items to prepend to the remote array.
 */
-(void)finishRefreshingWithItems:(NSArray*)items;

/**
 Subclasses should pass this message to themselves if they fail to load data for refreshing the remote array.
 
 Overriding this message should not be necessary to implement a subclass of SVRemoteArray.
 
 @param error The error that caused the failure. This parameter is optional.
 */
-(void)failRefreshingWithError:(NSError*)error;

@end
