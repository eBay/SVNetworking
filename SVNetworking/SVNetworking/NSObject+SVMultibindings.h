//
//  NSObject+SVMultibindings.h
//  RedLaser
//
//  Created by Nate Stedman on 10/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

/**
 An object containing the values of the key paths for a multibinding created with NSObject(SVMultibindings), in the
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
 A minimal KVO-based property binding system for observing multiple source object and key path pairs.
 
 @warning While this category has a similar API to NSObject(SVBindings), the two categories do not explicitly interact.
 It is possible to set both a binding and a multibinding for a single key path, the results of which are undefined and
 depend on the internal implementation of KVO.
 */
@interface NSObject (SVMultibindings)

/** @name Binding */
/**
 Multibinds a key path to an array of object and key path pairs.
 
 Multibindings must be removed when this object is deallocated. The most efficient way to do this is -sv_unmultibindAll.
 
 @param keyPath The key path to multibind.
 @param pairs The object and key path pairs to bind to. These should be objects returned from the `SVMultibindPair`
 function.
 @param block A block to reduce the bound values to a single value. This block will recieve an instance of
 SVMultibindArray, with values in the same order as the `pairs` parameter.
 */
-(void)sv_multibind:(NSString*)keyPath toObjectAndKeyPathPairs:(NSArray*)pairs withBlock:(SVMultibindBlock)block;

/** @name Unbinding */

/**
 Unmultibinds a key path.
 
 This message is less efficient than -sv_unmultibindAll. When cleaning up all bindings for an object during
 deallocation, use that message instead.
 
 @param keyPath The key path to unbind.
 */
-(void)sv_unmultibind:(NSString*)keyPath;

/**
 Removes all multibindings from the receiver.
 */
-(void)sv_unmultibindAll;

@end
