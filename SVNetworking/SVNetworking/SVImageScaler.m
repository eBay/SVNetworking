//
//  SVImageScaler.m
//  SVNetworking
//
//  Created by Nate Stedman on 3/19/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import "SVImageScaler.h"

@implementation SVImageScaler

+(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size withScale:(CGFloat)scale
{
    // calculate the correct image size to scale to
    CGSize const imageSize = image.size;
    CGFloat ratio = MIN(size.width / imageSize.width, size.height / imageSize.height);
    CGSize fitSize = {
        roundf(imageSize.width * ratio),
        roundf(imageSize.height * ratio)
    };
    
    // find out if the image has an alpha channel
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    BOOL hasAlpha = alpha == kCGImageAlphaFirst ||
                    alpha == kCGImageAlphaLast ||
                    alpha == kCGImageAlphaPremultipliedFirst ||
                    alpha == kCGImageAlphaPremultipliedLast;
    
    // scale the image
    UIGraphicsBeginImageContextWithOptions(fitSize, !hasAlpha, scale);
    [image drawInRect:CGRectMake(0.0, 0.0, fitSize.width, fitSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+(void)scaleImage:(UIImage*)image toSize:(CGSize)size withScale:(CGFloat)scale completion:(void(^)(UIImage *scaledImage))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // scale the image
        UIImage *scaledImage = [self scaleImage:image toSize:size withScale:scale];
        
        // move back to the main thread for completion
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion(scaledImage);
            }
        });
    });
}

@end
