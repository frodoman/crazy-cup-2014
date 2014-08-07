//
//  UIFont+WCFont.m
//  WorldCup
//
//  Created by XH Liu on 23/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "UIFont+WCFont.h"

NSString *const kWFMainFontName =@"TradeGothicLTStd-Cn18";

@implementation UIFont (WCFont)

+(UIFont*)wcFont_H1
{
    return [UIFont wcFontWithSize: 25.0f];
}

+(UIFont*)wcFont_H2
{
    return [UIFont wcFontWithSize: 22.0f];
}
+(UIFont*)wcFont_H3
{
    return [UIFont wcFontWithSize: 19.0f];
}
+(UIFont*)wcFont_H4
{
    return [UIFont wcFontWithSize: 16.0f];
}
+(UIFont*)wcFont_H5
{
    return [UIFont wcFontWithSize: 12.0f];
}


+(UIFont*)wcFontWithSize:(CGFloat)fSize
{
    UIFont *wfFont = [UIFont fontWithName: kWFMainFontName size:fSize];
    
     /*
     // useful for debugging to check the name of the font
      
     for (NSString *familyName in [UIFont familyNames]) {
     for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
     NSLog(@"%@", fontName);
     }
     }*/
    if( [WCUserSettings  systemLanguageInChinese])
    {
        wfFont = [UIFont systemFontOfSize: fSize-2.0f];
    }
    
    return wfFont;
}


@end
