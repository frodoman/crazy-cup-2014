//
//  WCIAdViewController.h
//  WorldCup
//
//  Created by XH Liu on 23/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"
#import <iAd/iAd.h>

@interface WCIAdViewController : WCBaseViewController
<ADBannerViewDelegate>

@property(nonatomic, strong) ADBannerView  *iAdView;
@property(nonatomic, strong) IBOutlet UILabel *labelMessage;
@property(nonatomic, strong) IBOutlet UILabel *labelVersion;

@end
