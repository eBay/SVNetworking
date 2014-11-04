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

#if os(iOS)
    import UIKit
    public typealias SVImageType = UIImage
#else
    import Cocoa
    public typealias SVImageType = NSImage
#endif

public class SVImageScaler: NSObject
{
    public class func scaleImage(image: SVImageType, toSize size: CGSize, withScale scale: CGFloat) -> SVImageType
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
    
    public class func scaleImage(image: SVImageType, toSize size: CGSize, withScale scale: CGFloat, completion: (SVImageType) -> Void)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () in
            let scaled = self.scaleImage(image, toSize: size, withScale: scale)
            
            dispatch_async(dispatch_get_main_queue(), { () in
                completion(scaled)
            })
        })
    }
}
