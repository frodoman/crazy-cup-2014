//
//  WCOneTipViewController.m
//  WorldCup
//
//  Created by Xinghou Liu on 11/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCOneTipViewController.h"
#import "WorldCup-Prefix.pch"

@interface WCOneTipViewController ()

@end

@implementation WCOneTipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor mainNavigationBarColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addBoarderToAllSubViews
{
    for (UIView *aView in self.view.subviews)
    {
        [aView addBorderStyle];
    }
    
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.borderWidth = 1.0f;
    
}

@end
