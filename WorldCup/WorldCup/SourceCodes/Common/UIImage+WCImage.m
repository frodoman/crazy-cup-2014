//
//  UIImage+WCImage.m
//  WorldCup
//
//  Created by XH Liu on 29/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "UIImage+WCImage.h"
#import "NSString+Common.h"
#import "NSObject+Consts.h"

@implementation UIImage (WCImage)

+(UIImage*)imageForTeam: (NSString*)imageName
{
    NSString *name = [imageName removeSpaces];
    UIImage *image = [UIImage wcImageNamed: name];
    if( image == nil)
    {
        image = [UIImage wcImageNamed: kWCImageNameFootBall];
    }
    return image;
}


+(UIImage*)imageForTeamLogo: (NSString*)imageName
{
    NSString *name = [imageName removeSpaces];
    NSString *newName = [name stringByAppendingString:@"_logo"];
    
    UIImage *image = [UIImage wcImageNamed: newName];
    
    return image;
}

// the default imageNamed: function will catch the image,
// because we will use lots of images in this app, we need to prevent image catches,
// otherwise this app will crash soon by running out of memory
//
+(UIImage *)wcImageNamed: (NSString*)imageName
{
    NSString *strName = [imageName copy];
    
    if( [UIScreen mainScreen].scale>1.0f)
    {
        strName = [imageName stringByAppendingString:@"@2x"];
    }
        
    NSString *path = [[NSBundle mainBundle] pathForResource:strName ofType:@"png"];
    
    if (path == nil)
    {
        path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

// return a black and white image
- (UIImage *)imageBlackAndWhite
{
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}

@end
