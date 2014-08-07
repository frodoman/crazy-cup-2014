//
//  WCFavouriteButtonViewController.m
//  WorldCup
//
//  Created by XH Liu on 30/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCFavouriteButtonViewController.h"
#import "UIImage+WCImage.h"
#import "NSObject+Consts.h"
#import "WCUserSettings.h"
#import <QuartzCore/QuartzCore.h>

 
@interface WCFavouriteButtonViewController ()


@end

@implementation WCFavouriteButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUIs];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated ];
    
    if ([WCUserSettings favouriteOrNotTeamWithIndex: self.view.tag])
    {
        self.buttonMain.selected = YES;
    }
    else
    {
        self.buttonMain.selected = NO;
    }
    
    [self showImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Inits
-(void)initUIs
{
    //button
    self.buttonMain.backgroundColor = [UIColor clearColor];
    self.buttonMain.selected = NO;
    self.buttonMain.alpha = 1.0f;
    
    self.backgroundView.image = [UIImage imageNamed:kWCUnFavouriteTeamImage];
    self.selectedImageView.image= [UIImage imageNamed: kWCFavouriteTeamImage];
    self.selectedImageView.alpha = 0.0f;
    
    self.view.backgroundColor = [UIColor clearColor];
    
}


#pragma mark - Actions
-(IBAction)mainButtonTapped:(id)sender
{
    self.buttonMain.selected = !self.buttonMain.selected;
    
    [self showImage];
    
    [WCUserSettings setFavourite: self.buttonMain.selected withIndex: self.view.tag];
}

-(void)showImage
{
    if(self.buttonMain.selected)
    {
        [self showSelectedImage];
    }
    else
    {
        [self showDefaultImage];
    }
}

-(void)showSelectedImage: (BOOL)selected
{
    self.buttonMain.selected = selected;
    
    [self showImage];
}


#pragma mark - Animations
-(void)showSelectedImage
{
    [UIView animateWithDuration:kWCAnimationDurationInSeconds1x
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.selectedImageView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0f);
                         self.selectedImageView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                     
                         if(finished)
                         {
                             [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                                              animations:^{
                                                  self.selectedImageView.layer.transform =CATransform3DIdentity;
                                              
                                              }];
                         }
                     }];
}

-(void)showDefaultImage
{
    [UIView animateWithDuration:kWCAnimationDurationInSeconds1x
                          delay:0.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.selectedImageView.layer.transform = CATransform3DMakeScale(0.2f, 0.2f, 1.0f);
                         self.selectedImageView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){}];
}


@end
