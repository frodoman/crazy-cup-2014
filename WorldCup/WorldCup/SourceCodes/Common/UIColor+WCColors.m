//
//  UIColor+WCColors.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "UIColor+WCColors.h"

@implementation UIColor (WCColors)

+(UIColor*)lightGreenColor
{
    UIColor *color = [UIColor colorWithRed:135.0f/255.0f green:204.0f/255.0f blue:0.0f alpha:1.0f];
    return color;
}

+(UIColor*)darkGreenColor
{
    UIColor *color = [UIColor colorWithRed:105.0f/255.0f green:153.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    return color;
}

+(UIColor*)lightPurpleColor
{
    UIColor *color = [UIColor colorWithRed:204.0f/255.0f green:153.0f/255.0f blue:1.0f alpha:1.0f];
    return color;
}


+(UIColor *) textColorLight
{
    return [UIColor whiteColor];
}
+(UIColor *) mainTextColor
{
    return [UIColor darkGreenColor];
}
+(UIColor *) mainBorderColor
{
    return [UIColor lightGreenColor];
}

+(UIColor *) viewSelectedColor
{
    return [UIColor lightPurpleColor];
}

+(UIColor *) mainNavigationBarColor
{
    return [UIColor lightGreenColor];
}

@end
