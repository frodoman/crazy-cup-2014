//
//  WCResultsViewController.h
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCResultsViewController : WCBaseViewController

@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) NSMutableArray *subScrollViews;

@end
