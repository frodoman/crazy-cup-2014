//
//  WCInfoViewController.h
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

extern NSString *const kWCURLStringRateTheApp;
extern NSString *const kWCURLStringForSharingTheApp;

@interface WCInfoViewController : WCBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
