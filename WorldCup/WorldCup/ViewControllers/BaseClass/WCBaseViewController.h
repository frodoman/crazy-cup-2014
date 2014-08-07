//
//  WCBaseViewController.h
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCMainMenuViewController;
@class WCViewController;

@interface WCBaseViewController : UIViewController

@property(nonatomic, weak)  WCMainMenuViewController *mainMenuController;
@property(nonatomic, weak)  WCViewController *rootController;

@property(nonatomic) BOOL viewHasBeenShown;

-(id)initWithDefaultNib;
-(void)startWaiting;
-(void)stopWaiting;

-(void)setTranslusionEffectWithColor: (UIColor*)color;
-(void) initViewControllers;

-(void)updateTitleAndPageController;
-(void)showLatestInformation;

-(void)addCloseButtonToNavigationBar;

-(UIView*)translusionBackgroundViewWithColor : (UIColor*)color;

@end
