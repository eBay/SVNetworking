/*
 Copyright (c) 2014 eBay Software Foundation
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 Redistributions in binary form must reproduce the above copyright notice, this
 list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 Neither the name of eBay or any of its subsidiaries or affiliates nor the names
 of its contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
