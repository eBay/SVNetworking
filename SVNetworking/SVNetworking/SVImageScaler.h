//
//  SVImageScaler.h
//  SVNetworking
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides image scaling class methods.
 */
@interface SVImageScaler : NSObject

/**
 Synchronously scales an image to the specified size and scale.
 */
+(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size withScale:(CGFloat)scale;

/**
 Asynchronously scales an image to the specified size and scale.
 
 The completion handler will be called on the main thread.
 */
+(void)scaleImage:(UIImage*)image toSize:(CGSize)size withScale:(CGFloat)scale completion:(void(^)(UIImage *scaledImage))completion;

@end
