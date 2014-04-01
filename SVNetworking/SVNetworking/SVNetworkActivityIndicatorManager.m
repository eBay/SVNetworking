//
//  SVNetworkActivityIndicatorManager.m
//  SVNetworking
//
//  Created by Nate Stedman on 4/1/14.
//  Copyright (c) 2014 Svpply. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVNetworkActivityIndicatorManager.h"

@interface SVNetworkActivityIndicatorManager ()
{
@private
    NSUInteger _count;
}

@end

@implementation SVNetworkActivityIndicatorManager

-(void)increaseNetworkActivityIndicatorCount
{
    _count++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = _count > 0;
}

-(void)decreaseNetworkActivityIndicatorCount
{
    if (_count > 0)
    {
        _count--;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = _count > 0;
}

@end
