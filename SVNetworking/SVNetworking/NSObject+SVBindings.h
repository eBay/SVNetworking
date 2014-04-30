/**
 A compile-time checker for key path generation. Goodbye, magic strings!
 */
#define SV_KEYPATH(object, path) ({ typedef __typeof((object).path) foo; @ #path; })
#define SV_CLASS_KEYPATH(class, path) SV_KEYPATH((class*)nil, path)

typedef id(^SVBindingBlock)(id value);

/**
 An object containing the values of the key paths for a multibinding created with NSObject(SVBindings), in the
 order that they were passed as pairs.
 
 This object does not provide a "count" property.
 
 Generally, there is no reason that an instance of this object should outlive the multibinding block that it is passed
 to.
 */
@interface SVMultibindArray : NSObject

/**
 Returns the object at the specified index.
 
 Note that, unlike `NSArray`, `nil` is a valid value, and will not be replaced with `NSNull` (`NSNull` may occur, of
 course, but only if it is the actual value of a bound key path).
 
 @param subscript The index to return.
 @returns The object at the specified index.
 */
-(id)objectAtIndexedSubscript:(NSUInteger)subscript;

@end

typedef id(^SVMultibindBlock)(SVMultibindArray *values);

FOUNDATION_EXTERN id SVMultibindPair(id object, NSString* keyPath);

/**
 A minimal KVO-based property binding system for `NSObject` subclasses.
 
 Supports both one-to-one bindings, with an optional transformation block, and bindings to multiple targets, reduced to
 a single value with a block.
 */
@interface NSObject (SVBindings)

#pragma mark - Binding
/** @name Binding */

/**
 Binds a key path.
 
 When the target key path changes, the key path of this object will be automatically set.
 
 Bindings must be removed when this object is deallocated. The most efficient way to do this is `-sv_unbindAll`.
 
 @param keyPath The key path to bind.
 @param object The object to bind to.
 @param boundKeyPath The key path to bind to.
 */
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath;

/**
 Binds a key path with a transformation block.
 
 When the target key path changes, the key path of this object will be automatically set.
 
 Bindings must be removed when this object is deallocated. The most efficient way to do this is `-sv_unbindAll`.
 
 @param keyPath The key path to bind.
 @param object The object to bind to.
 @param boundKeyPath The key path to bind to.
 @param block A block that the new value of `boundKeyPath` will be passed to. The receiver's key path will be set to the
 value returned from the block.
 */
-(void)sv_bind:(NSString*)keyPath toObject:(id)object withKeyPath:(NSString*)boundKeyPath block:(SVBindingBlock)block;

#pragma mark - Multibinding
/** @name Multibinding */
/**
 Multibinds a key path to an array of object and key path pairs.
 
 Multibindings must be removed when this object is deallocated. The most efficient way to do this is `-sv_unbindAll`.
 
 @param keyPath The key path to multibind.
 @param pairs The object and key path pairs to bind to. These should be objects returned from the `SVMultibindPair`
 function.
 @param block A block to reduce the bound values to a single value. This block will recieve an instance of
 `SVMultibindArray`, with values in the same order as the `pairs` parameter.
 */
-(void)sv_multibind:(NSString*)keyPath toObjectAndKeyPathPairs:(NSArray*)pairs withBlock:(SVMultibindBlock)block;

#pragma mark - Unbinding
/** @name Unbinding */

/**
 Unbinds a key path.
 
 This message is less efficient than `-sv_unbindAll`. When cleaning up all bindings for an object during deallocation, use
 that message instead.
 
 @param keyPath The key path to unbind.
 */
-(void)sv_unbind:(NSString*)keyPath;

/**
 Removes all key path bindings.
 */
-(void)sv_unbindAll;

@end
