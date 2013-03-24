//
//  RDSStyleDefaults.m
//  Reade.rs
//
//  Created by Frederic Jacobs on 9/2/13.
//  Copyright (c) 2013 Frederic Jacobs. All rights reserved.
//

#import "RDSStyleDefaults.h"

@implementation RDSStyleDefaults

#pragma mark Navigation Bar

+ (UIColor *) colorForNavigationBar{
    return [UIColor colorWithIntRed:10 green:23 blue:46 alpha:1];
}

+ (UIFont *) fontForNavigationBar{
    return [UIFont fontWithName:@"YanoneKaffeesatz-Regular" size:50];
}

+ (UIColor *) colorForNavigationBarText{
    return [UIColor colorWithIntRed:229 green:221 blue:221 alpha:1];
}

@end
