//
//  SVFunctional.h
//  RedLaser
//
//  Created by Nate Stedman on 4/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

typedef id(^SVMapToIntegerBlock)(NSUInteger i);
FOUNDATION_EXTERN  __attribute((pure)) NSArray* SVMapToInteger(NSUInteger integer, SVMapToIntegerBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSArray* SVFilterMapToInteger(NSUInteger integer, SVMapToIntegerBlock block);

typedef id(^SVMapBlock)(id object);
FOUNDATION_EXTERN  __attribute((pure)) NSArray* SVMap(NSArray* array, SVMapBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSArray* SVFilterMap(NSArray* array, SVMapBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSSet* SVMapSet(NSSet* set, SVMapBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSDictionary* SVMapToDictionaryObjects(NSArray *array, SVMapBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSDictionary* SVMapToDictionaryKeys(NSArray *array, SVMapBlock block);

typedef void(^SVDoubleMapToDictionaryBlock)(id object, id *key, id *value);
FOUNDATION_EXTERN  __attribute((pure)) NSDictionary* SVDoubleMapToDictionary(NSArray *array, SVDoubleMapToDictionaryBlock block);

typedef id(^SVMapDictionaryBlock)(id key, id object);
FOUNDATION_EXTERN __attribute((pure)) NSDictionary* SVMapDictionary(NSDictionary *dictionary, SVMapDictionaryBlock block);

typedef BOOL(^SVFilterBlock)(id object);
FOUNDATION_EXTERN  __attribute((pure)) NSArray* SVFilter(NSArray* array, SVFilterBlock block);

typedef BOOL(^SVAllBlock)(id object);
FOUNDATION_EXTERN  __attribute((pure)) BOOL SVAll(id<NSFastEnumeration> enumerable, SVAllBlock block);

typedef BOOL(^SVAnyBlock)(id object);
FOUNDATION_EXTERN  __attribute((pure)) BOOL SVAny(id<NSFastEnumeration> enumerable, SVAnyBlock block);

typedef BOOL(^SVFindBlock)(id object);
FOUNDATION_EXTERN  __attribute((pure)) id SVFind(id<NSFastEnumeration> enumerable, SVFindBlock block);
FOUNDATION_EXTERN  __attribute((pure)) NSUInteger SVFindIndex(id<NSFastEnumeration> enumerable, SVFindBlock block);

typedef void(^SVDoubleIterateBlock)(id object1, id object2);
FOUNDATION_EXTERN void SVDoubleIterate(NSArray *array1, NSArray *array2, SVDoubleIterateBlock block);

typedef id(^SVInterleaveBlock)(void);
FOUNDATION_EXTERN NSArray* SVInterleave(NSArray *array, SVInterleaveBlock block);

typedef BOOL(^SVGroupBlock)(id object1, id object2);
FOUNDATION_EXTERN NSArray *SVGroup(NSArray *array, SVGroupBlock block);

typedef double(^SVDoubleComparisonBlock)(id object);
FOUNDATION_EXTERN id SVMinObjectDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block);
FOUNDATION_EXTERN double SVMinDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block);

FOUNDATION_EXTERN NSDictionary *SVBucketToDictionary(id<NSFastEnumeration> enumerable, SVMapBlock block);

typedef id(^SVIfNotNilBlock)(id object);
FOUNDATION_STATIC_INLINE id SVIfNotNil(id object, SVIfNotNilBlock block)
{
    return object ? block(object) : nil;
}
