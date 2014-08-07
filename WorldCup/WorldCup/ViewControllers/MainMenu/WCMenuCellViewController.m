//
//  WCMenuCellViewController.m
//  WorldCup
//
//  Created by XH Liu on 20/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCMenuCellViewController.h"
#import "NSObject+Consts.h"
#import "WCMainMenuItem.h"
#import "UIColor+WCColors.h"
#import "ILTranslucentView.h"
#import "UIFont+WCFont.h"
#import <QuartzCore/QuartzCore.h>

@interface WCMenuCellViewController ()

@end

@implementation WCMenuCellViewController

-(id)initWithMenuItem: (WCMainMenuItem*) menuItem
{
    self = [super initWithDefaultNib];
    if(self)
    {
        self.menuData = menuItem;
        
    }
    return self;
}


-(id)initWithDictionary: (NSDictionary*) aDic
{
    self = [super initWithDefaultNib];
    if (self)
    {
        self.labelTitle.text = [aDic objectForKey: kJsonKeyMainMenuTitle];
        
        NSString *strName = [aDic objectForKey: kJsonKeyMainMenuImage];
        self.imageView.image = [UIImage imageNamed: strName];
        
        //self.viewControllerToPresent = [aDic objectForKey: kJsonKeyMainMenuClass];
    }
    return self;
}

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
    
    [self initLayer  ];
    [self initMenuData];
    [self initLabels];
    [self initMaskView];
    
    self.imageView.layer.borderColor = [UIColor darkGreenColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Inits

-(void)initLayer
{
    [self.view.layer setCornerRadius: kWCViewCornerRadius ];
    [self.view.layer setBorderColor: [UIColor lightGreenColor].CGColor];
    [self.view.layer setBorderWidth: kWCViewBoarderWidth];
    [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.view.layer setShadowOffset:CGSizeMake(-50, 50.0f)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    // UIView *bgView = [self translusionBackgroundViewWithColor: [UIColor blackColor]];
    //[self.view insertSubview:bgView belowSubview:self.imageView ];
    
    //ILTranslucentView *rootView = (ILTranslucentView*)self.view;
    //rootView.tintColor = [UIColor blackColor];
    //[self setTranslusionEffectWithColor: [UIColor darkGreenColor]];
//    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [blur setDefaults];
//    [self.view.layer setBackgroundFilters: [NSArray arrayWithObject: blur]];
}

-(void) initLabels
{
    self.labelTitle.textColor =[UIColor darkGreenColor];
    
    self.labelTitle.font = [UIFont wcFont_H1];
    
    self.labelSubTitle.textColor = [UIColor darkGreenColor];
    self.labelSubTitle.font = [UIFont wcFont_H3];

}

-(void) initMenuData
{
    self.labelTitle.text = NSLocalizedString(self.menuData.title, nil);
    self.labelSubTitle.hidden = YES;
    self.imageView.image =[UIImage imageNamed: self.menuData.imageName];
    //self.imageView.alpha = 0.6f;
}

-(void)initMaskView
{
    CGRect oldFrame = self.view.bounds;
    CGRect frame =CGRectMake(-oldFrame.size.width, -oldFrame.size.height,
                             oldFrame.size.width*2.0f, oldFrame.size.height*2.0f);
    self.imageViewMask = [[UIImageView alloc] initWithFrame: frame];
    self.imageViewMask.backgroundColor = [UIColor whiteColor];
    self.imageViewMask.alpha = 0.8f;
    self.imageViewMask.image = [UIImage imageNamed:kWCMainMenuMaskImageName];
    
    self.imageViewMask.layer.anchorPoint = CGPointMake(0.7f, 1.0f);
    self.imageViewMask.frame = frame;
 
    
    self.imageViewMask.clipsToBounds = YES;
    self.view.clipsToBounds = YES;
    
    [self.view.layer insertSublayer: self.imageViewMask.layer above: self.imageView.layer];
 
}

#pragma mark - Animations
-(void) rotateToGoUp
{
    [self hideContentToTop:YES];
}

-(void)rotateToGoDown
{
    [self hideContentToTop:NO];
}

-(void)hideContentToTop: (BOOL)onTop
{

    CATransform3D transform = self.view.layer.transform;
    transform.m34 = -[NSObject transform3D_M34];//-2.0f/500.0f;
    
    if(onTop)
    {
        self.view.layer.transform = CATransform3DRotate(transform, M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    }
    else
    {
        self.view.layer.transform = CATransform3DRotate(transform, -M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    }
}

-(void)rotateToHide
{
    CATransform3D transform = self.view.layer.transform;
    transform.m34 = [NSObject transform3D_M34];//-2.0f/800.0f;
    
    self.view.layer.transform = CATransform3DRotate(transform, M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    self.view.alpha = 0.0f;
    
}

-(void)animateMaskViewToShowContent
{
 
    [UIView animateWithDuration: kWCAnimationDurationInSeconds2x
                          delay: 0.15f
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     
                         self.imageView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0f);
                         self.imageViewMask.layer.transform = CATransform3DMakeRotation(M_PI*6.0f/7.0f, 0.0f, 0.0f, 1.0f);
                     }
                     completion:^(BOOL finished){
                     
                         if(finished)
                         {
                             [UIView animateWithDuration:kWCAnimationDurationInSeconds1x
                                              animations:^{
                                              
                                              self.imageView.layer.transform = CATransform3DIdentity;
                                              }];
                         }
                     }];
}

@end
