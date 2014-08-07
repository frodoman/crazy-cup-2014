//
//  WCViewController.h
//  WorldCup
//
//  Created by XH Liu on 30/04/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WCBaseViewController.h"

@class WCMainMenuViewController;
@class WCIAdViewController;

@interface WCViewController : UIViewController

@property(nonatomic) BOOL showingIAdView;

@property(nonatomic, strong) WCMainMenuViewController *mainMenuController;
@property(nonatomic, strong) WCIAdViewController *iAdController;

@end
