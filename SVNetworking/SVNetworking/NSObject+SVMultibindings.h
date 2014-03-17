//
//  NSObject+SVMultibindings.h
//  RedLaser
//
//  Created by Nate Stedman on 10/3/13.
//  Copyright (c) 2013 eBay, Inc. All rights reserved.
//

@interface SVMultibindArray : NSObject

-(id)objectAtIndexedSubscript:(NSUInteger)subscript;

@end

typedef id(^SVMultibindBlock)(SVMultibindArray *values);

FOUNDATION_EXTERN id SVMultibindPair(id object, NSString* keyPath);

@interface NSObject (SVMultibindings)

-(void)sv_multibind:(NSString*)keyPath toObjectAndKeyPathPairs:(NSArray*)pairs withBlock:(SVMultibindBlock)block;
-(void)sv_unmultibind:(NSString*)keyPath;
-(void)sv_unmultibindAll;

@end
