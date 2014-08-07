//
//  WCTitleViewController.h
//  WorldCup
//
//  Created by XH Liu on 22/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCTitleViewController : WCBaseViewController

@property(nonatomic, strong) IBOutlet UIPageControl *pageController;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic) SEL onTapAction;
@property(nonatomic, weak) id target;


@end
