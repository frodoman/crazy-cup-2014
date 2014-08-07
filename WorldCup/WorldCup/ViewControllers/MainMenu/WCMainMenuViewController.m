//
//  WCMainMenuViewController.m
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMainMenuViewController.h"
#import "WCMenuCellViewController.h"
#import "WCMainMenuItem.h"
#import "NSObject+Consts.h"
#import "UIColor+WCColors.h"
#import "WCTitleViewController.h"
#import "UIFont+WCFont.h"
#import "WCTipsViewController.h"

const CGFloat kWcMainMenuTimeLabelHeight = 40.0f;

@interface WCMainMenuViewController ()
@property(nonatomic, strong) WCMenuCellViewController *selectedCellController;
@end

@implementation WCMainMenuViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initViewControllers];
    [self addActionsToViews];
    [self initLabels];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated ];
    
    self.mainScrollView.frame = CGRectMake(0, kWCMainMenuTitleHeight,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height-kWCMainMenuTitleHeight);
    
    static BOOL hasDoneThis = NO;
    if(!hasDoneThis)
    {
        [self hideAllCellViewsForFirstTimeDisplay];
        hasDoneThis  =YES;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static BOOL hasDoneThis = NO;
    if(!hasDoneThis)
    {
        [self animateToShowContentForTheFirstTime];
        hasDoneThis = YES;
    }
}

#pragma mark - Public
-(void)updateTitle: (NSString*)newTitle
{
    self.titleController.labelTitle.text = newTitle;
}

-(void)showPageIndicator: (BOOL)showIndicator
{
    self.titleController.pageController.hidden = !showIndicator;
}

-(void)setNumberOfPages: (NSUInteger) pageNumber
{
    [self.titleController.pageController setNumberOfPages: pageNumber ];
}

-(void)setSelectedPageWithIndex: (NSUInteger) pageIndex
{
    [self.titleController.pageController setCurrentPage: pageIndex];
}

-(NSUInteger)currentPageIndex
{
    NSUInteger index = self.titleController.pageController.currentPage;
    return index;
}

#pragma mark - Inits
-(void)initViewControllers
{
    NSArray *menuItems = [WCMainMenuItem mainMenuItems];
    
    //init all the views
    NSMutableArray *viewArray = [NSMutableArray array];
    for( WCMainMenuItem *oneItem in menuItems)
    {
        WCMenuCellViewController *aView = [[WCMenuCellViewController alloc] initWithMenuItem:oneItem ];
        [viewArray addObject: aView ];
    }
    self.menuViewControllers = [[NSArray alloc] initWithArray: viewArray ];
    
    // change the frame of each view
    CGRect viewFrame = CGRectMake(kWCSpaceBetweenViews, 0,
                                  self.view.frame.size.width - kWCSpaceBetweenViews*2.0f,
                                  kWCMainMenuCellViewHeight );
    for( NSUInteger viewIndex = 0; viewIndex< self.menuViewControllers.count; viewIndex++)
    {
        WCMenuCellViewController *oneController = [self.menuViewControllers objectAtIndex: viewIndex];
        oneController.view.frame = viewFrame;
        oneController.view.tag = viewIndex;
        
        viewFrame = CGRectOffset(viewFrame, 0, kWCMainMenuCellViewHeight+kWCSpaceBetweenViews);
        [self.mainScrollView addSubview:  oneController.view ];
    }
    
    //correct the scroll view content size
    [self.mainScrollView setContentSize: CGSizeMake(self.view.frame.size.width,
                                                    kWCSystemStatusBarHeight+ kWcMainMenuTimeLabelHeight + [NSObject iAdViewHeight]+
                                                    (kWCMainMenuCellViewHeight+kWCSpaceBetweenViews)*self.menuViewControllers.count) ];
    
    [self initTitleController];
    [self initUpdateTimeLabel];
}

-(void)initUpdateTimeLabel
{
    NSString *localTimeString = [WCDataEntities sharedDataManager].allGames.updatedTime.localTimeString;
    if(!localTimeString || localTimeString.length==0)
    {
        return;
    }
    
    WCMenuCellViewController *cellController = self.menuViewControllers.lastObject;
    
    self.labelUpdatedTime = nil;
    self.labelUpdatedTime = [[UILabel alloc] initWithFrame: CGRectMake( cellController.view.frame.origin.x,
                                                                   cellController.view.frame.origin.y + kWCMainMenuCellViewHeight+kWCSpaceBetweenViews,
                                                                   self.mainScrollView.frame.size.width,
                                                                   kWcMainMenuTimeLabelHeight)];
    self.labelUpdatedTime.font = [UIFont wcFont_H2];
    self.labelUpdatedTime.textAlignment = NSTextAlignmentCenter;
    self.labelUpdatedTime.textColor = [UIColor whiteColor];
    
    self.labelUpdatedTime.text = [NSString stringWithFormat:@"%@ %@",
                                  NSLocalizedString(@"Last Updated:",nil), localTimeString ];
    
    [self.mainScrollView addSubview: self.labelUpdatedTime ];
}

-(void)initTitleController
{
    self.titleController = [[WCTitleViewController alloc] initWithDefaultNib ];
    self.titleController.view.frame = [self titleViewHiddenFrame];
    self.titleController.view.alpha = 1.0f;
    [self.view addSubview: self.titleController.view];
    
    self.titleController.target = self;
    self.titleController.onTapAction = @selector(titleViewTapped:);
}

-(void) addActionsToViews
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action: @selector(mainScrollViewTapped:) ];
    tap.numberOfTapsRequired = 1;
    
    [self.mainScrollView addGestureRecognizer: tap ];
    
}

-(void)initPresentationViewController
{
    if(self.viewControllers==nil)
    {
        self.viewControllers = [NSMutableArray array];
    }
    
    NSString *controllerName = self.selectedCellController.menuData.controllerClassName;
    id ViewController = NSClassFromString(controllerName);
    
    WCBaseViewController *foundViewController = [self viewControllerWithClass: ViewController];
    if( self.viewControllers.count==0 ||
        foundViewController == nil)
    {
        WCBaseViewController *vController = [[ViewController alloc] initWithDefaultNib ];
        vController.view.alpha = 0.0f;
        vController.view.backgroundColor = [UIColor clearColor];
        vController.view.frame = CGRectMake(0, kWCMainMenuTitleHeight,
                                                                self.view.frame.size.width,
                                                                self.view.frame.size.height - kWCMainMenuTitleHeight);
        
        [self.viewControllers addObject: vController];
        self.presentationViewController = vController;
    }
    else
    {
        [self.presentationViewController.view removeFromSuperview];
        self.presentationViewController = foundViewController;
    }
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [NSObject transform3D_M34]; //2.0f/800.0f;
    transform = CATransform3DScale(transform, 1.3f, 1.3f, 1.0f);
    transform = CATransform3DRotate(transform, -M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    self.presentationViewController.view.layer.transform = transform;
    
    [self.presentationViewController updateTitleAndPageController];
    
    [self.view insertSubview:self.presentationViewController.view belowSubview: self.mainScrollView];

    
}

-(void)initLabels
{
    self.labelTitle.text = NSLocalizedString(@"World Cup 2014", nil);
    self.labelTitle.font = [UIFont wcFont_H1];
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.layer.cornerRadius = 2.0f;
    
}

#pragma mark - Sub Menu View Controllers
-(WCBaseViewController*)viewControllerWithClass: (id)ClassName
{
    if(self.viewControllers.count==0)
    {
        return nil;
    }
    
    WCBaseViewController *foundController = nil;
    for(WCBaseViewController *vController in self.viewControllers)
    {
        if([vController isKindOfClass: ClassName ])
        {
            foundController = vController;
            break;
        }
    }
    
    return foundController;
}

#pragma mark - UI
-(void)applyVisibleFramesForAllCellViews
{
    CGRect viewFrame = CGRectMake(kWCSpaceBetweenViews, 0,
                                  self.view.frame.size.width - kWCSpaceBetweenViews*2.0f,
                                  kWCMainMenuCellViewHeight );
    
    for( NSUInteger viewIndex = 0; viewIndex< self.menuViewControllers.count; viewIndex++)
    {
        WCMenuCellViewController *oneController = [self.menuViewControllers objectAtIndex: viewIndex];
        oneController.view.frame = viewFrame;
        oneController.view.alpha = 1.0f;
        oneController.view.layer.transform = CATransform3DIdentity;
        viewFrame = CGRectOffset(viewFrame, 0, kWCMainMenuCellViewHeight+kWCSpaceBetweenViews);
    }
}

#pragma mark - Actions
-(void) mainScrollViewTapped: (UITapGestureRecognizer*)tap
{
    CGPoint tapPoint = [tap locationInView: self.mainScrollView];
    
    //find the cell view tapped
    WCMenuCellViewController *cellViewTapped = nil;
    for( WCMenuCellViewController *cellController in self.menuViewControllers)
    {
        CGRect frame = cellController.view.frame;
        if(CGRectContainsPoint(frame, tapPoint))
        {
            cellViewTapped = cellController;
            break;
        }
    }
    self.selectedCellController = cellViewTapped;
    self.selectedCellController.view.backgroundColor = [UIColor viewSelectedColor];
    
    if(cellViewTapped)
    {
        [self initPresentationViewController];
        
        [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                         animations:^{
                         
                             [self.selectedCellController rotateToHide];
                         }
                         completion:^(BOOL finished){
                         
                             if(finished)
                             {
                                 
                             }
                         
                         }];
        
        [self hideAllCellViewsAndShowPresentationView];
        
    }
}

-(void)titleViewTapped:(id)sender
{
    [self animateToShowAllCellView];
}

#pragma mark - Locaitons

-(CGRect) topHiddenFrameForCellView
{
    CGRect frame = CGRectMake(0, -kWCMainMenuCellViewHeight, self.view.frame.size.width, kWCMainMenuCellViewHeight);
    return frame;
}

-(CGRect)bottomHiddenFrameForCellView
{
    CGRect frame = CGRectMake(0, self.mainScrollView.contentSize.height, self.view.frame.size.width, kWCMainMenuCellViewHeight);
    return frame;
}

-(CGRect)titleViewHiddenFrame
{
    CGRect frame = CGRectMake(0, -kWCMainMenuTitleHeight , self.view.frame.size.width, kWCMainMenuTitleHeight);
    return frame;
}

-(CGRect)titleViewVisibleFrame
{
    CGRect frame = CGRectMake(0, 0 , self.view.frame.size.width, kWCMainMenuTitleHeight);
    return frame;
}


#pragma mark - Animations

-(void)animationToShowContents
{
    [self animateToShowContentForTheFirstTime];
}

-(void)animateToShowContentForTheFirstTime
{
    if(self.animationHappening)
    {
        return;
    }
    self.animationHappening = YES;
    self.labelTitle.alpha = 0.0f;
    [UIView animateWithDuration: kWCAnimationDurationInSeconds4x
                          delay: kWCAnimationDurationInSeconds1x
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                     
                         [self applyVisibleFramesForAllCellViews];
                         self.labelTitle.alpha = 1.0f;
                     
                     }  completion:^(BOOL finished){
                     
                     
                         if(finished)
                         {
                             self.animationHappening = NO;
                             [self animateToRemoveCellViewMasks: [NSNumber numberWithInteger:0]];
                         }
                     }];
}

-(void)animateToRemoveCellViewMasks:(NSNumber*)numberIndex
{
    NSUInteger cellIdex = [numberIndex integerValue];
    if(cellIdex>=self.menuViewControllers.count)
    {
        //show how to use for the first time
        if( [WCUserSettings appNeverOpened])
        {
            WCTipsViewController *tipController = [[WCTipsViewController alloc] initWithDefaultNib ];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tipController];
            [tipController addCloseButtonToNavigationBar];
            
            [self.rootController presentViewController: navController
                                              animated:YES
                                            completion:nil ];
        }
        
        return;
    }
    
    WCMenuCellViewController *vController = [self.menuViewControllers objectAtIndex: cellIdex];
    [vController animateMaskViewToShowContent];
    
    [self performSelector: @selector(animateToRemoveCellViewMasks:)
               withObject: [NSNumber numberWithInteger: cellIdex+1] afterDelay:0.1f];
    
}

-(void)hideAllCellViewsForFirstTimeDisplay
{
    CGRect viewFrame = CGRectMake(kWCSpaceBetweenViews, 0,
                                  self.view.frame.size.width - kWCSpaceBetweenViews*2.0f,
                                  kWCMainMenuCellViewHeight );
    
    for( NSUInteger viewIndex = 0; viewIndex< self.menuViewControllers.count; viewIndex++)
    {
        WCMenuCellViewController *oneController = [self.menuViewControllers objectAtIndex: viewIndex];
        
        CGFloat xOrigin = arc4random()%((NSInteger)viewFrame.size.width);
        CGFloat yOrigin = arc4random()%((NSInteger)viewFrame.size.height);
        if(viewIndex%2==0)
        {
            xOrigin = -1.0f *xOrigin;
            yOrigin = -1.0f *yOrigin;
        }
        
        oneController.view.frame = CGRectMake(xOrigin, yOrigin, viewFrame.size.width, viewFrame.size.height);
        oneController.view.alpha = 0.0f;
        
    }
}

-(void)animateToShowAllCellView
{
    if(self.animationHappening)
    {
        return;
    }
    self.animationHappening = YES;
    
    self.mainScrollView.hidden = NO;
    self.labelTitle.alpha = 1.0f;
    [UIView animateWithDuration: kWCAnimationDurationInSeconds4x
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         //hide the cell views
                         [self applyVisibleFramesForAllCellViews];
                         for( WCMenuCellViewController *oneController in self.menuViewControllers)
                         {
                             oneController.view.layer.transform = CATransform3DIdentity;
                         }
                         self.labelUpdatedTime.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             for( WCMenuCellViewController *oneController in self.menuViewControllers)
                             {
                                 oneController.view.backgroundColor = [UIColor whiteColor];
                             }
                             
                             self.animationHappening = NO;
                             self.showingPresentationView = NO;
                         }
                     }];
    
    [self animateToHidePresentationView ];
    [self animateToHideTitleView];
    
}




-(void)hideAllCellViewsAndShowPresentationView
{
    if(self.animationHappening)
    {
        return;
    }
    self.animationHappening = YES;
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds3x
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         //hide the cell views 
                         for( WCMenuCellViewController *oneController in self.menuViewControllers)
                         {
                             if(oneController.view.tag > self.selectedCellController.view.tag)
                             {
                                 [oneController  rotateToGoDown];
                                 oneController.view.frame = [self bottomHiddenFrameForCellView];
                                 
                             }
                             else if(oneController.view.tag < self.selectedCellController.view.tag)
                             {
                                 [oneController rotateToGoUp];
                                 oneController.view.frame = [self topHiddenFrameForCellView];
                             }
                             else
                             {
                                 
                             }
                         }
                         
                         self.labelTitle.alpha = 0.0f;
                         self.labelUpdatedTime.alpha = 0.0f;
                         [self animateToShowPresentationView ];
                         [self animateToShowTitleView];

                     }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             self.mainScrollView.hidden = YES;
                             self.animationHappening = NO;
                             
                             self.showingPresentationView = YES;
                         }
                     }];
}

-(void)animateToHideTitleView
{
    [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                          delay: 0.2f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        
                         self.titleController.view.frame = [self titleViewHiddenFrame];
                    }
                     completion:^(BOOL finished){
                     if(finished)
                     {
                         
                     }
                         
                     }];
}


-(void)animateToShowTitleView
{
    [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                          delay: 0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.titleController.view.frame =  CGRectOffset([self titleViewVisibleFrame], 0, kWCSpaceBetweenViews*6);
                         
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                         {
                             [UIView animateWithDuration: 0.2f
                                              animations:^{
                             
                                 self.titleController.view.frame = [self titleViewVisibleFrame];
                             }];
                         }
                     }];
}

-(void)animateToHidePresentationView
{
 
    [UIView animateWithDuration: kWCAnimationDurationInSeconds2x
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CATransform3D transform = CATransform3DIdentity;
                         transform.m34 = [NSObject transform3D_M34];
                         transform = CATransform3DScale(transform, 0.5f, 0.5f, 1.0f);
                         transform = CATransform3DRotate(transform, -M_PI/2.0f, 1.0f, 0.0f, 0.0f);
                         self.presentationViewController.view.layer.transform =  transform;
                         
                         self.presentationViewController.view.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                         {
                             
                         }
                     }];
}

-(void)animateToShowPresentationView
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, 0.7f, 0.7f, 1.0f);
    
    //find the scroll view in the presentation view
    UIScrollView *scrollView = nil;
    for (UIView *aSubView in self.presentationViewController.view.subviews)
    {
        if([aSubView isKindOfClass: [UIScrollView class]] &&
           ![aSubView isKindOfClass: [UITableView class]])
        {
            scrollView = (UIScrollView*)aSubView;
            break;
        }
    }
    CGRect scrollFrame;
    if(scrollView)
    {
        scrollFrame= scrollView.frame;
        scrollView.frame = CGRectMake(scrollView.frame.origin.x,
                                      scrollView.frame.origin.y,
                                      scrollView.frame.size.width*1.5f,
                                      scrollView.frame.size.height);
        
    }
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds3x
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.presentationViewController.view.layer.transform = transform;
                         self.presentationViewController.view.alpha = 1.0f;
                         
                     }
                     completion:^(BOOL finished) {
                         if(finished)
                         {
                             [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  self.presentationViewController.view.layer.transform =CATransform3DIdentity;
                                                  scrollView.frame = scrollFrame;
                                              }
                                              completion:^(BOOL finished) {
                                              
                                                  if(finished)
                                                  {
                                                      [self.presentationViewController showLatestInformation];
                                                  }
                                              }];
                                                  
                         }
                     
                     }];
}


@end
