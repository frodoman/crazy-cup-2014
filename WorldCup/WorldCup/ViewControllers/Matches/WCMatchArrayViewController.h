//
//  WCMatchArrayViewController.h
//  WorldCup
//
//  Created by Xinghou Liu on 01/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCMatchArrayViewController : WCBaseViewController
<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *matchArray;


-(id)initWithTeamName:(NSString*)teamName;
-(id)initWithLocationCityName: (NSString*)cityName;

@end
