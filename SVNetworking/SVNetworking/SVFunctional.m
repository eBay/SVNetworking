//
//  SVFunctional.m
//  RedLaser
//
//  Created by Nate Stedman on 4/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

#import "SVFunctional.h"

NSArray* SVMapToInteger(NSUInteger integer, SVMapToIntegerBlock block)
{
    if (integer > 0)
    {
        __autoreleasing id* mapped = (__autoreleasing id*)malloc(sizeof(id) * integer);
        
        for (NSUInteger i = 0; i < integer; i++)
            mapped[i] = block(i);
        
        NSArray* array = [NSArray arrayWithObjects:mapped count:integer];
        free(mapped);
        return array;
    }
    else return @[];
}

NSArray* SVFilterMapToInteger(NSUInteger integer, SVMapToIntegerBlock block)
{
    if (integer > 0)
    {
        __autoreleasing id* mapped = (__autoreleasing id*)malloc(sizeof(id) * integer);
        
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < integer; i++)
        {
            mapped[index] = block(i);
            if (mapped[index]) index++;
        }
        
        NSArray* array = [NSArray arrayWithObjects:mapped count:index];
        free(mapped);
        return array;
    }
    else return @[];
}

NSArray* SVMap(NSArray* array, SVMapBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* mapped = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            mapped[i] = block(object);
            i++;
        }
        
        NSArray* array = [NSArray arrayWithObjects:mapped count:count];
        free(mapped);
        return array;
    }
    else return @[];
}

NSArray* SVFilterMap(NSArray* array, SVMapBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* mapped = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            mapped[i] = block(object);
            if (mapped[i]) i++;
        }
        
        NSArray* array = [NSArray arrayWithObjects:mapped count:i];
        free(mapped);
        return array;
    }
    else return @[];
}

NSSet* SVMapSet(NSSet* set, SVMapBlock block)
{
    NSMutableSet *mapped = [NSMutableSet setWithCapacity:set.count];
    
    for (id object in set)
    {
        [mapped addObject:block(object)];
    }
    
    return mapped;
}

NSDictionary* SVMapToDictionaryObjects(NSArray *array, SVMapBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* keys = (__autoreleasing id*)malloc(sizeof(id) * count);
        __autoreleasing id* objects = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            keys[i] = object;
            objects[i] = block(object);
            i++;
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
        free(keys);
        free(objects);
        return dictionary;
    }
    else return @{};
}

NSDictionary* SVMapToDictionaryKeys(NSArray *array, SVMapBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* keys = (__autoreleasing id*)malloc(sizeof(id) * count);
        __autoreleasing id* objects = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            objects[i] = object;
            keys[i] = block(object);
            i++;
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
        free(keys);
        free(objects);
        return dictionary;
    }
    else return @{};
}

NSDictionary* SVDoubleMapToDictionary(NSArray *array, SVDoubleMapToDictionaryBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* keys = (__autoreleasing id*)malloc(sizeof(id) * count);
        __autoreleasing id* objects = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            block(object, keys + i, objects + i);
            i++;
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
        free(keys);
        free(objects);
        return dictionary;
    }
    else return @{};
}

NSDictionary* SVMapDictionary(NSDictionary *dictionary, SVMapDictionaryBlock block)
{
    NSUInteger count = dictionary.count;
    __unsafe_unretained id keys[count], objects[count], mappedObjects[count];
    [dictionary getObjects:objects andKeys:keys];
    
    for (NSUInteger i = 0; i < count; i++)
    {
        mappedObjects[i] = block(keys[i], objects[i]);
    }
    
    return [NSDictionary dictionaryWithObjects:mappedObjects forKeys:keys count:count];
}

NSArray* SVFilter(NSArray* array, SVFilterBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        __autoreleasing id* filtered = (__autoreleasing id*)malloc(sizeof(id) * count);
        
        NSUInteger i = 0;
        for (id object in array)
        {
            if (block(object))
            {
                filtered[i] = object;
                i++;
            }
        }
        
        NSArray* array = [NSArray arrayWithObjects:filtered count:i];
        free(filtered);
        return array;
    }
    else return @[];
}

BOOL SVAll(id<NSFastEnumeration> enumerable, SVAllBlock block)
{
    for (id object in enumerable)
    {
        if (!block(object)) return NO;
    }
    
    return YES;
}

BOOL SVAny(id<NSFastEnumeration> enumerable, SVAnyBlock block)
{
    for (id object in enumerable)
    {
        if (block(object)) return YES;
    }
    
    return NO;
}

id SVFind(id<NSFastEnumeration> enumerable, SVFindBlock block)
{
    for (id object in enumerable)
    {
        if (block(object))
        {
            return object;
        }
    }
    
    return nil;
}

NSUInteger SVFindIndex(id<NSFastEnumeration> enumerable, SVFindBlock block)
{
    NSUInteger index = 0;
    
    for (id object in enumerable)
    {
        if (block(object))
        {
            return index;
        }
        
        index++;
    }
    
    return NSNotFound;
}

NSArray *SVInterleave(NSArray *array, SVInterleaveBlock block)
{
    NSUInteger count = array.count;
    
    if (count > 1)
    {
        __autoreleasing id* interleaved = (__autoreleasing id*)malloc(sizeof(id) * (count * 2 - 1));
        
        NSUInteger i = 0;
        for (id item in array)
        {
            interleaved[i * 2] = item;
            
            if (i + 1 < count)
            {
                interleaved[i * 2 + 1] = block();
            }
            
            i++;
        }
        
        NSArray *results = [NSArray arrayWithObjects:interleaved count:count * 2 - 1];
        free(interleaved);
        return results;
    }
    else
    {
        return array;
    }
}

NSArray *SVGroup(NSArray *array, SVGroupBlock block)
{
    NSMutableArray *grouped = [NSMutableArray array];
    NSUInteger count = array.count;
    
    if (count > 0)
    {
        NSMutableArray *current = [NSMutableArray array];
        [current addObject:array[0]];
        [grouped addObject:current];
        
        for (NSUInteger i = 1; i < count; i++)
        {
            id object1 = array[i - 1], object2 = array[i];
            
            if (!block(object1, object2))
            {
                current = [NSMutableArray array];
                [grouped addObject:current];
            }
            
            [current addObject:object2];
        }
    }
    
    return [NSArray arrayWithArray:grouped];
}

id SVMinObjectDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block)
{
    id minObject = nil;
    double minDouble = DBL_MAX;
    
    for (id currentObject in enumerable)
    {
        double currentDouble = block(currentObject);
        
        if (currentDouble < minDouble)
        {
            minDouble = currentDouble;
            minObject = currentObject;
        }
    }
    
    return minObject;
}

double SVMinDouble(id<NSFastEnumeration> enumerable, SVDoubleComparisonBlock block)
{
    double minDouble = DBL_MAX;
    
    for (id currentObject in enumerable)
    {
        double currentDouble = block(currentObject);
        
        if (currentDouble < minDouble)
        {
            minDouble = currentDouble;
        }
    }
    
    return minDouble;
}

NSDictionary *SVBucketToDictionary(id<NSFastEnumeration> enumerable, SVMapBlock block)
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (id object in enumerable)
    {
        id key = block(object);
        NSMutableArray *array = dictionary[key];
        
        if (!array)
        {
            array = [NSMutableArray arrayWithCapacity:1];
            dictionary[key] = array;
        }
        
        [array addObject:object];
    }
    
    return dictionary;
}
