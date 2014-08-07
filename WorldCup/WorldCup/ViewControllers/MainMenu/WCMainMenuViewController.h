//
//  WCMainMenuViewController.h
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@class WCTitleViewController;

@interface WCMainMenuViewController : WCBaseViewController

@property(nonatomic, strong) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong ) UILabel *labelUpdatedTime;

@property(nonatomic, strong) WCBaseViewController *presentationViewController;
@property(nonatomic, strong) WCTitleViewController *titleController;
@property(nonatomic, strong) NSMutableArray *viewControllers;

@property(nonatomic) BOOL showingPresentationView;
@property(nonatomic) BOOL animationHappening;

@property(nonatomic, strong) NSArray *menuViewControllers;

-(void)updateTitle: (NSString*)newTitle;
-(void)showPageIndicator: (BOOL)showIndicator;
-(void)setNumberOfPages: (NSUInteger) pageNumber;
-(void)setSelectedPageWithIndex: (NSUInteger) pageIndex;

-(NSUInteger)currentPageIndex;

-(void)animationToShowContents;

@end
