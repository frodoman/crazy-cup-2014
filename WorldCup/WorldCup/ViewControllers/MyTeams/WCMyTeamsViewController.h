//
//  WCMyTeamsViewController.h
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCMyTeamsViewController : WCBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) NSMutableArray *tableViews;
@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;

@end
