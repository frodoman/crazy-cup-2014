//
//  NSString+Common.m
//  WorldCup
//
//  Created by Xinghou Liu on 26/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

-(NSString*)removeSpaces
{
    NSString *strReturn = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  strReturn;
}

@end
