/**
 A compile-time checker for key path generation. Goodbye, magic strings!
 */
#define SV_KEYPATH(object, path) ({ typedef __typeof((object).path) foo; @ #path; })
#define SV_CLASS_KEYPATH(class, path) SV_KEYPATH((class*)nil, path)

typedef id(^SVBindingBlock)(id value);

/**
 A minimal KVO-based property binding system for NSObject subclasses.
 
 @warning While this category has a similar API to NSObject(SVMultibindings), the two categories do not explicitly
 interact. It is possible to set both a binding and a multibinding for a single key path, the results of which are
 undefined and depend on the internal implementation of KVO.
 */
@interface NSObject (SVBindings)

#pragma mark - Binding
/** @name Binding */

/**
 Binds a key path.
 
 When the target key path changes, the key path of this object will be automatically set.
 
 Bindings must be removed when this object is deallocated. The most efficient way to do this is -sv_unbindAll.
 
 @param keyPath The key path to bind.
 @param object The object to bind to.
 @param boundKeyPath The key path to bind to.
 */
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath;

/**
 Binds a key path with a transformation block.
 
 When the target key path changes, the key path of this object will be automatically set.
 
 Bindings must be removed when this object is deallocated. The most efficient way to do this is -sv_unbindAll.
 
 @param keyPath The key path to bind.
 @param object The object to bind to.
 @param boundKeyPath The key path to bind to.
 @param block A block that the new value of boundKeyPath will be passed to. The receiver's key path will be set to the
 value returned from the block.
 */
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath block:(SVBindingBlock)block;

#pragma mark - Unbinding
/** @name Unbinding */

/**
 Unbinds a key path.
 
 This message is less efficient than -sv_unbindAll. When cleaning up all bindings for an object during deallocation, use
 that message instead.
 
 @param keyPath The key path to unbind.
 */
-(void)sv_unbind:(NSString*)keyPath;

/**
 Removes all key path bindings.
 */
-(void)sv_unbindAll;

@end
