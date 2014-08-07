//
//  UIImage+WCImage.h
//  WorldCup
//
//  Created by XH Liu on 29/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WCImage)

+(UIImage*)imageForTeam: (NSString*)imageName;
+(UIImage*)imageForTeamLogo: (NSString*)imageName;

- (UIImage *)imageBlackAndWhite;

@end
