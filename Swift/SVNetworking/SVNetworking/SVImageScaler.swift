//
//  SVImageScaler.swift
//  SVNetworking
//
//  Created by Nate Stedman on 10/8/14.
//  Copyright (c) 2014 eBay. All rights reserved.
//

#if os(iOS)
    import UIKit
    typealias SVImageType = UIImage
#else
    import Cocoa
    typealias SVImageType = NSImage
#endif

class SVImageScaler: NSObject
{
    class func scaleImage(image: SVImageType, toSize size: CGSize, withScale scale: CGFloat) -> SVImageType
    {
        // calculate the correct size to scale the image to
        let imageSize = image.size
        let ratio = min(size.width / imageSize.width, size.height / imageSize.height)
        let fitSize = CGSize(width: round(imageSize.width * ratio), height: round(imageSize.height * ratio))
        
        // scale the image
        #if os(iOS)
            let alpha = CGImageGetAlphaInfo(image.CGImage)
            
            let hasAlpha = alpha == .First
                        || alpha == .Last
                        || alpha == .PremultipliedFirst
                        || alpha == .PremultipliedLast
            
            UIGraphicsBeginImageContextWithOptions(fitSize, !hasAlpha, scale)
            image.drawInRect(CGRect(x: 0, y: 0, width: fitSize.width, height: fitSize.height))
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        #else
            let scaledImage = NSImage(size: fitSize)
            scaledImage.lockFocus()
            image.drawInRect(NSRect(x: 0, y: 0, width: fitSize.width, height: fitSize.height))
            scaledImage.unlockFocus()
        #endif
        
        return scaledImage
    }
    
    class func scaleImage(image: SVImageType, toSize size: CGSize, withScale scale: CGFloat, completion: (SVImageType) -> Void)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () in
            let scaled = self.scaleImage(image, toSize: size, withScale: scale)
            
            dispatch_async(dispatch_get_main_queue(), { () in
                completion(scaled)
            })
        })
    }
}
