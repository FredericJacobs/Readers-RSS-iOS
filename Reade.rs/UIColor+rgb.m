//
//  UIColor+rgb.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "UIColor+rgb.h"

@implementation UIColor (rgb)

+ (UIColor *)colorWithIntRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [self colorWithRed:red/255. green:green/255. blue:blue/255. alpha:alpha];
}

@end
