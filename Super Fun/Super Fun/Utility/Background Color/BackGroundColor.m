//
//  BackGroundColor.m
//  Room_Matcher
//
//  Created by Dev Thakur on 18/09/14.
//  Copyright (c) 2014 Avnish Sharma. All rights reserved.
//

#import "BackGroundColor.h"

@implementation BackGroundColor

+(UIColor *)backgroundColorForView:(NSString *)image
{
    UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:image]];
    return color;
}
@end
