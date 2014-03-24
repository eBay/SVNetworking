//
//  NSObject+SVMultibindings.m
//  RedLaser
//
//  Created by Nate Stedman on 10/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+SVMultibindings.h"

@interface SVMultibindArray ()
{
@private
    NSUInteger _count;
    __strong id* _values;
}

@end

@implementation SVMultibindArray

+(instancetype)arrayWithValues:(id __autoreleasing *)values count:(NSUInteger)count
{
    SVMultibindArray* array = [SVMultibindArray new];
    
    if (array)
    {
        array->_count = count;
        array->_values = (__strong id*)calloc(count, sizeof(id));
        
        for (NSUInteger i = 0; i < count; i++)
        {
            array->_values[i] = values[i];
        }
    }
    
    return array;
}

-(void)dealloc
{
    for (NSUInteger i = 0; i < _count; i++)
    {
        _values[i] = nil;
    }
    
    free(_values);
}

-(id)objectAtIndexedSubscript:(NSUInteger)subscript
{
    return _values[subscript];
}

@end

@interface SVMultibindingPair : NSObject
@property (readwrite, unsafe_unretained) id object;
@property (readwrite, strong) NSString* keyPath;
@end

@implementation SVMultibindingPair

-(NSString*)description
{
    return [[super description] stringByAppendingFormat:@" (%@ -> %@)", _object, _keyPath];
}

@end

id SVMultibindPair(id object, NSString* keyPath)
{
    SVMultibindingPair* pair = [SVMultibindingPair new];
    pair.object = object;
    pair.keyPath = [keyPath copy];
    return pair;
}

@interface SVMultibinding : NSObject
{
@private
    __unsafe_unretained id object;
    NSString* keyPath;
    NSArray* pairs;
    SVMultibindBlock block;
}

-(instancetype)initWithTargetObject:(id)object keyPath:(NSString*)keyPath pairs:(NSArray*)pairs block:(SVMultibindBlock)block;

@end

@implementation SVMultibinding

-(instancetype)initWithTargetObject:(id)_object keyPath:(NSString*)_keyPath pairs:(NSArray*)_pairs block:(SVMultibindBlock)_block
{
    self = [self init];
    
    if (self)
    {
        pairs = _pairs;
        object = _object;
        keyPath = [_keyPath copy];
        block = [_block copy];
        
        for (SVMultibindingPair* pair in pairs)
        {
            [pair.object addObserver:self forKeyPath:pair.keyPath options:0 context:NULL];
        }
        
        [self observeValueForKeyPath:nil ofObject:nil change:nil context:NULL];
    }
    
    return self;
}

-(void)dealloc
{
    for (SVMultibindingPair* pair in pairs)
    {
        [pair.object removeObserver:self forKeyPath:pair.keyPath];
    }
}

-(void)observeValueForKeyPath:(NSString*)path ofObject:(id)obj change:(NSDictionary*)change context:(void*)context
{
    NSUInteger count = pairs.count;
    
    if (count > 0)
    {
        __autoreleasing id values[count];
        
        for (NSUInteger i = 0; i < count; i++)
        {
            SVMultibindingPair* pair = pairs[i];
            values[i] = [pair.object valueForKeyPath:pair.keyPath];
        }
        
        SVMultibindArray* array = [SVMultibindArray arrayWithValues:values count:count];
        [object setValue:block(array) forKeyPath:keyPath];
    }
}

@end

@implementation NSObject (SVMultibindings)

static char MBAssociatedKey;

-(void)sv_multibind:(NSString*)keyPath toObjectAndKeyPathPairs:(NSArray*)pairs withBlock:(SVMultibindBlock)block
{
    NSMutableDictionary* bindings = objc_getAssociatedObject(self, &MBAssociatedKey);
    if (!bindings)
    {
        bindings = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, &MBAssociatedKey, bindings, OBJC_ASSOCIATION_RETAIN);
    }
    
    SVMultibinding* binding = [[SVMultibinding alloc] initWithTargetObject:self keyPath:keyPath pairs:pairs block:block];
    bindings[keyPath] = binding;
}

-(void)sv_unmultibind:(NSString*)keyPath
{
    NSMutableDictionary* bindings = objc_getAssociatedObject(self, &MBAssociatedKey);
    [bindings removeObjectForKey:keyPath];
    
    if (bindings.count == 0)
    {
        objc_setAssociatedObject(self, &MBAssociatedKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
}

-(void)sv_unmultibindAll
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &MBAssociatedKey);
    [dictionary removeAllObjects];
    objc_setAssociatedObject(self, &MBAssociatedKey, nil, OBJC_ASSOCIATION_RETAIN);
}

@end
