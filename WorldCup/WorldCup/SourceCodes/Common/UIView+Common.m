//
//  UIView+Common.m
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "UIView+Common.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Common)

// add round corder to the view
-(void)addBorderStyle
{
    self.layer.borderWidth = kWCViewBoarderWidth;
    self.layer.borderColor = [UIColor mainBorderColor].CGColor;
    self.layer.cornerRadius = kWCViewCornerRadius;
}


@end
