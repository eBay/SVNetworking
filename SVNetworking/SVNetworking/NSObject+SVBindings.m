#import <objc/runtime.h>
#import "NSObject+SVBindings.h"

@interface SVBindingInternal : NSObject
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

@implementation SVBindingInternal

-(instancetype)initWithObject:(id)object
            keyPath:(NSString*)keyPath
            boundTo:(id)boundObject
            keyPath:(NSString*)boundKeyPath
              block:(SVBindingBlock)block
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
    id value = [_boundObject valueForKeyPath:_boundKeyPath];
    [_object setValue:_block ? _block(value) : value forKeyPath:_keyPath];
}

@end

@implementation NSObject (SVBindings)

static char SVAssociatedKey;

#pragma mark - Binding
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath
{
    [self sv_bind:keyPath toObject:object withKeyPath:boundKeyPath block:nil];
}

-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath block:(SVBindingBlock)block
{
    // create bindings dictionary if necessary
    NSMutableDictionary* bindings = objc_getAssociatedObject(self, &SVAssociatedKey);
    if (!bindings)
    {
        bindings = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, &SVAssociatedKey, bindings, OBJC_ASSOCIATION_RETAIN);
    }
    
    // add new binding
    SVBindingInternal* binding = [[SVBindingInternal alloc] initWithObject:self
                                                                   keyPath:keyPath
                                                                   boundTo:object
                                                                   keyPath:boundKeyPath
                                                                     block:block];
    bindings[keyPath] = binding;
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

@end
