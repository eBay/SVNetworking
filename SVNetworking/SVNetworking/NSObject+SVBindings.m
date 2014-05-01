#import <objc/runtime.h>
#import "NSObject+SVBindings.h"

#pragma mark - Multibind Supporting Classes
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

#pragma mark - Binding Class Interfaces
@interface SVBinding : NSObject

@property (nonatomic) BOOL suspended;

-(void)apply;

@end

@interface SVSingleBinding : SVBinding
{
@private
    // objects
    __unsafe_unretained id _object;
    __unsafe_unretained id _boundObject;
    
    // key paths
    NSString* _keyPath;
    NSString* _boundKeyPath;
    
    // transformation
    SVBindingBlock _block;
}

-(instancetype)initWithObject:(id)object
                      keyPath:(NSString*)keyPath
                      boundTo:(id)boundObject
                      keyPath:(NSString*)boundKeyPath
                        block:(SVBindingBlock)block;

@end

@interface SVMultibinding : SVBinding
{
@private
    __unsafe_unretained id _object;
    NSString* _keyPath;
    NSArray* _pairs;
    SVMultibindBlock _block;
}

-(instancetype)initWithObject:(id)object
                      keyPath:(NSString*)keyPath
                        pairs:(NSArray*)pairs
                        block:(SVMultibindBlock)block;

@end

#pragma mark - Private NSObject Additions
@interface NSObject (SVBindingsPrivate)

-(void)sv_addSuspendedBinding:(SVBinding*)binding;
-(void)sv_drainSuspendedBindings;

@end

@implementation NSObject (SVBindingsPrivate)

static char SVSuspendedBindingsKey;

-(void)sv_addSuspendedBinding:(SVBinding *)binding
{
    NSMutableSet* bindings = objc_getAssociatedObject(self, &SVSuspendedBindingsKey);
    
    if (!bindings)
    {
        bindings = [NSMutableSet setWithObject:binding];
        objc_setAssociatedObject(self, &SVSuspendedBindingsKey, bindings, OBJC_ASSOCIATION_RETAIN);
    }
    else
    {
        [bindings addObject:binding];
    }
}

-(void)sv_drainSuspendedBindings
{
    NSSet *set = objc_getAssociatedObject(self, &SVSuspendedBindingsKey);
    objc_setAssociatedObject(self, &SVSuspendedBindingsKey, nil, OBJC_ASSOCIATION_RETAIN);
    
    for (SVBinding *binding in set)
    {
        binding.suspended = NO;
        [binding apply];
    }
}

@end

#pragma mark - Binding Class Implementations
@implementation SVBinding

-(void)apply {}

@end

@implementation SVSingleBinding

-(instancetype)initWithObject:(id)object
                      keyPath:(NSString*)keyPath
                      boundTo:(id)boundObject
                      keyPath:(NSString*)boundKeyPath
                        block:(SVBindingBlock)block;
{
    self = [self init];
    
    if (self)
    {
        _object = object;
        _keyPath = [keyPath copy];
        _boundObject = boundObject;
        _boundKeyPath = [boundKeyPath copy];
        _block = [block copy];
        
        [boundObject addObserver:self forKeyPath:boundKeyPath options:0 context:NULL];
        [self observeValueForKeyPath:nil ofObject:nil change:nil context:NULL];
    }
    
    return self;
}

-(void)dealloc
{
    [_boundObject removeObserver:self forKeyPath:_boundKeyPath];
}

-(void)observeValueForKeyPath:(NSString*)path ofObject:(id)obj change:(NSDictionary*)change context:(void*)context
{
    if (self.suspended)
    {
        [_object sv_addSuspendedBinding:self];
    }
    else
    {
        [self apply];
    }
}

-(void)apply
{
    id value = [_boundObject valueForKeyPath:_boundKeyPath];
    [_object setValue:_block ? _block(value) : value forKeyPath:_keyPath];
}

@end

@implementation SVMultibinding

-(instancetype)initWithObject:(id)object
                      keyPath:(NSString *)keyPath
                        pairs:(NSArray *)pairs
                        block:(SVMultibindBlock)block
{
    self = [self init];
    
    if (self)
    {
        _pairs = pairs;
        _object = object;
        _keyPath = [keyPath copy];
        _block = [block copy];
        
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
    for (SVMultibindingPair* pair in _pairs)
    {
        [pair.object removeObserver:self forKeyPath:pair.keyPath];
    }
}

-(void)observeValueForKeyPath:(NSString*)path ofObject:(id)obj change:(NSDictionary*)change context:(void*)context
{
    if (self.suspended)
    {
        [_object sv_addSuspendedBinding:self];
    }
    else
    {
        [self apply];
    }
}

-(void)apply
{
    NSUInteger count = _pairs.count;
    
    if (count > 0)
    {
        __autoreleasing id values[count];
        
        for (NSUInteger i = 0; i < count; i++)
        {
            SVMultibindingPair* pair = _pairs[i];
            values[i] = [pair.object valueForKeyPath:pair.keyPath];
        }
        
        SVMultibindArray* array = [SVMultibindArray arrayWithValues:values count:count];
        [_object setValue:_block(array) forKeyPath:_keyPath];
    }
}

@end

#pragma mark - Category Implementation
@implementation NSObject (SVBindings)

static char SVAssociatedKey;

#pragma mark - Binding
-(void)sv_bind:(NSString *)keyPath withBindingObject:(SVBinding*)binding
{
    // create bindings dictionary if necessary
    NSMutableDictionary* bindings = objc_getAssociatedObject(self, &SVAssociatedKey);
    if (!bindings)
    {
        bindings = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, &SVAssociatedKey, bindings, OBJC_ASSOCIATION_RETAIN);
    }
    
    // add new binding
    bindings[keyPath] = binding;
}

-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath
{
    [self sv_bind:keyPath toObject:object withKeyPath:boundKeyPath block:nil];
}

-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath block:(SVBindingBlock)block
{
    SVSingleBinding* binding = [[SVSingleBinding alloc] initWithObject:self
                                                               keyPath:keyPath
                                                               boundTo:object
                                                               keyPath:boundKeyPath
                                                                 block:block];
    [self sv_bind:keyPath withBindingObject:binding];
}

-(void)sv_multibind:(NSString*)keyPath toObjectAndKeyPathPairs:(NSArray*)pairs withBlock:(SVMultibindBlock)block
{
    SVMultibinding* binding = [[SVMultibinding alloc] initWithObject:self
                                                             keyPath:keyPath
                                                               pairs:pairs
                                                               block:block];
    [self sv_bind:keyPath withBindingObject:binding];
}

#pragma mark - Unbinding
-(void)sv_unbind:(NSString*)keyPath
{
    @autoreleasepool
    {
        // remove binding
        NSMutableDictionary* bindings = objc_getAssociatedObject(self, &SVAssociatedKey);
        [bindings removeObjectForKey:keyPath];
        
        // clean up bindings dictionary if it is now empty
        if (bindings.count == 0)
        {
            objc_setAssociatedObject(self, &SVAssociatedKey, nil, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

-(void)sv_unbindAll
{
    @autoreleasepool
    {
        // just clear the bindings dictionary - bindings will automatically dealloc
        NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &SVAssociatedKey);
        [dictionary removeAllObjects];
        objc_setAssociatedObject(self, &SVAssociatedKey, nil, OBJC_ASSOCIATION_RETAIN);
    }
}

#pragma mark - Suspended Bindings
-(void)sv_suspendBindings:(void(^)(void))block
{
    NSMutableDictionary* bindings = objc_getAssociatedObject(self, &SVAssociatedKey);
    
    for (SVBinding *binding in bindings.allValues)
    {
        binding.suspended = YES;
    }
    
    block();
    
    [self sv_drainSuspendedBindings];
}

@end
