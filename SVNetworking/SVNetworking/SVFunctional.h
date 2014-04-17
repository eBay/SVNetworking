//
//  SVFunctional.h
//  RedLaser
//
//  Created by Nate Stedman on 4/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

#pragma mark - Map to Integer
/** @name Map to Integer */

/** Block type definition for `SVMapToInteger` and `SVFilterMapToInteger`. */
typedef id(^SVMapToIntegerBlock)(NSUInteger i);

/**
 Returns an array of the results of `block`, passed successive integers from `0` to `integer - 1`.
 
 `nil` is invalid in `NSArray`, and will result in an exception.
 
 @param integer The length of the result array.
 @param block The block to apply to each integer.
 */
FOUNDATION_EXTERN NSArray* SVMapToInteger(NSUInteger integer, SVMapToIntegerBlock block);

/**
 Returns an array of the results of `block`, passed successive integers from `0` to `integer - 1`.
 
 `nil` values will be removed.
 
 @param integer The maximum length of the result array, less any `nil` values.
 @param block The block to apply to each integer.
 */
FOUNDATION_EXTERN NSArray* SVFilterMapToInteger(NSUInteger integer, SVMapToIntegerBlock block);

#pragma mark - Map
/** @name Map */

/** Block type definition for `SVMap` and other mapping functions. */
typedef id(^SVMapBlock)(id object);

/**
 Maps `block` across the contents of `array`.
 
 `nil` is invalid in `NSArray`, and will result in an exception.
 
 @param array The source array.
 @param block The block to apply to each object in the array.
 */
FOUNDATION_EXTERN NSArray* SVMap(NSArray* array, SVMapBlock block);

/**
 Maps `block` across the contents of `array`.
 
 `nil` values will be removed.
 
 @param array The input array.
 @param block The block to apply to each object in the array.
 */
FOUNDATION_EXTERN NSArray* SVFilterMap(NSArray* array, SVMapBlock block);

/**
 Maps `block` across the contents of `set`.
 
 `nil` is invalid in `NSSet`, and will result in an exception.
 
 @param set The input set.
 @param block The block to apply to each object in the set.
 */
FOUNDATION_EXTERN NSSet* SVMapSet(NSSet* set, SVMapBlock block);

/**
 Maps `block` across the contents of `array`, returning a dictionary with the values from `array` as keys and the
 applied values as objects.
 
 `nil` is invalid in `NSDictionary`, and will result in an exception.
 
 @param array The input array.
 @param block The block to apply to each object in the array.
 */
FOUNDATION_EXTERN NSDictionary* SVMapToDictionaryObjects(NSArray *array, SVMapBlock block);

/**
 Maps `block` across the contents of `array`, returning a dictionary with the values from `array` as objects and the
 applied values as keys.
 
 `nil` is invalid in `NSDictionary`, and will result in an exception.
 
 @param array The input array.
 @param block The block to apply to each object in the array.
 */
FOUNDATION_EXTERN NSDictionary* SVMapToDictionaryKeys(NSArray *array, SVMapBlock block);

/** Block type definition for `SVDoubleMapToDictionary`. */
typedef void(^SVDoubleMapToDictionaryBlock)(id object, id *key, id *value);

/**
 Maps an array to an entire dictionary, using a block with out pointers.
 
 If you are setting either the key or value to the input object without any modifications, use
 `SVMapToDictionaryObjects` or `SVMapToDictionaryKeys` instead.
 
 @param array The input array.
 @param block The block to determine dictionary values and keys.
 */
FOUNDATION_EXTERN NSDictionary* SVDoubleMapToDictionary(NSArray *array, SVDoubleMapToDictionaryBlock block);

/** Block type definition for `SVMapDictionary`. */
typedef id(^SVMapDictionaryBlock)(id key, id object);

/**
 Maps a dictionary to a new set of objects, with the same keys.
 
 @param dictionary The source dictionary.
 @param block A block to process each key and object pair, returning a new object.
 */
FOUNDATION_EXTERN NSDictionary* SVMapDictionary(NSDictionary *dictionary, SVMapDictionaryBlock block);

#pragma mark - Filter
/** @name Filter */

/** Block type definition for `SVFilter`. */
typedef BOOL(^SVFilterBlock)(id object);

/**
 Returns a filtered array.
 
 @param array The input array.
 @param block A filter block - values for which this block returns `YES` will be included in the returned array.
 */
FOUNDATION_EXTERN NSArray* SVFilter(NSArray* array, SVFilterBlock block);

#pragma mark - Conditionals
/** @name Conditionals */

/** Block type definition for `SVAll`. */
typedef BOOL(^SVAllBlock)(id object);

/**
 Returns `YES` if `block` returns `YES` for all objects in `enumerable`.
 
 @param enumerable An enumerable object.
 @param block A block to validate each object in `enumerable`.
 */
FOUNDATION_EXTERN BOOL SVAll(id<NSFastEnumeration> enumerable, SVAllBlock block);

/** Block type definition for `SVAny`. */
typedef BOOL(^SVAnyBlock)(id object);

/**
 Returns `YES` if `block` returns `YES` for any object in `enumerable`.
 
 @param enumerable An enumerable object.
 @param block A block to validate each object in `enumerable`.
 */
FOUNDATION_EXTERN BOOL SVAny(id<NSFastEnumeration> enumerable, SVAnyBlock block);

#pragma mark - Finding
/** @name Finding */

/** Block type definition for `SVFind` and `SVFindIndex`. */
typedef BOOL(^SVFindBlock)(id object);

/**
 Returns the first object for which `block` returns `YES`.
 
 If `enumerable` is exhausted without `block` returning `YES`, returns `nil`.
 
 @param enumerable An enumerable object.
 @param block A block to apply to each object.
 */
FOUNDATION_EXTERN id SVFind(id<NSFastEnumeration> enumerable, SVFindBlock block);

/**
 Returns the index of the first object for which `block` returns `YES`.
 
 If `enumerable` is exhausted without `block` returning `YES`, returns `NSNotFound`.
 
 @warning For non-ordered enumerables, this function has undefined results.
 
 @param enumerable An enumerable object.
 @param block A block to apply to each object.
 */
FOUNDATION_EXTERN NSUInteger SVFindIndex(id<NSFastEnumeration> enumerable, SVFindBlock block);

#pragma mark - Interleave
/** @name Interleave */

/** Block type definition for `SVInterleave`. */
typedef id(^SVInterleaveBlock)(void);

/**
 Returns an array with the results of `block` placed between each pair of elements in `array`.
 
 @param array The input array.
 @param block A block, returning objects to place between elements of `array`.
 */
FOUNDATION_EXTERN NSArray* SVInterleave(NSArray *array, SVInterleaveBlock block);

#pragma mark - Grouping
/** @name Grouping */

/** Block type definition for `SVGroup`. */
typedef BOOL(^SVGroupBlock)(id object1, id object2);

/**
 Progressively groups an array into subarrays.
 
 Objects are added to the current array until `block` returns `NO`.
 
 The input array should already be sorted. Objects passed to the block will be sequential.
 
 @param array An array to group.
 @param block A block which receives two objects, and should return `YES` if they should be grouped together and `NO`
 otherwise.
 */
FOUNDATION_EXTERN NSArray *SVGroup(NSArray *array, SVGroupBlock block);

/** Block type definition for `SVGroupToDictionary`. */
typedef id<NSCopying>(^SVGroupToDictionaryBlock)(id object);

/**
 Groups objects into a dictionary of keys to arrays.
 
 Arrays are ordered sequentially in the order that their objects were passed to `block`. For non-ordered enumerables,
 this order is undefined.
 
 @param enumerable An input enumerable.
 @param block A block, which returns a dictionary key for the input object.
 */
FOUNDATION_EXTERN NSDictionary *SVGroupToDictionary(id<NSFastEnumeration> enumerable, SVGroupToDictionaryBlock block);

#pragma mark - Minimums
/** @name Minimums */

/** Block type definition for converting an object to a `double` representation. */
typedef double(^SVDoubleComparisonBlock)(id object);

/**
 Returns the object in `enumerable` for which `block` returns the lowest `double` value.
 
 @param enumerable The input enumerable.
 @param block A double conversion block.
 */
FOUNDATION_EXTERN id SVMinObjectDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block);

/**
 Returns the lowest `double` value returned from `block` while iterating over `enumerable`.
 
 @param enumerable The input enumerable.
 @param block A double conversion block.
 */
FOUNDATION_EXTERN double SVMinDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block);

#pragma mark - Maybe
/** @name Maybe */

/** Block type definition for `SVMaybe`. */
typedef id(^SVMaybeBlock)(id object);

/**
 Applies a block to an object and returns the result, unless the input object is `nil`. If the input object is `nil`,
 returns `nil`.
 
 A non-`nil` default value can be easily applied with the `?:` operator:
 
     self.property = SVMaybe(foo, ^id(id object) {
         return [object bar];
     }) ?: baz;
 
 @param object The input object, or `nil`.
 @param block A block to apply to non-`nil` input objects.
 */
FOUNDATION_STATIC_INLINE id SVMaybe(id object, SVMaybeBlock block)
{
    return object ? block(object) : nil;
}
