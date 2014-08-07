//
//  WCTipsViewController.h
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCTipsViewController : WCBaseViewController
<UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel *labelMessage;
@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UIPageControl *pageController;

@property(nonatomic, strong) NSMutableArray *tipsControllers;

@end
