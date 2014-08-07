//
//  WCMenuCellViewController.h
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@class  WCMainMenuItem;

@interface WCMenuCellViewController : WCBaseViewController

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UILabel *labelSubTitle;

@property(nonatomic, strong) UIImageView *imageViewMask;
//@property(nonatomic, strong) NSString *viewControllerToPresent;

@property(nonatomic, strong) WCMainMenuItem *menuData;

-(id)initWithDictionary: (NSDictionary*) aDic;
-(id)initWithMenuItem: (WCMainMenuItem*) menuItem;

-(void) rotateToGoUp;
-(void)rotateToGoDown;
-(void)rotateToHide;
-(void)animateMaskViewToShowContent;

@end
