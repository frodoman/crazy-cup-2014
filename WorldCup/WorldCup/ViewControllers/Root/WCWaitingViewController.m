//
//  WCWaitingViewController.m
//  WorldCup
//
//  Created by XH Liu on 03/06/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WorldCup-Prefix.pch"
#import "WCWaitingViewController.h"

CGFloat const kWCWaitingImageViewSize = 100.0f;
NSUInteger const kWCWaitingImageViewsCountEachAnimation = 3;
NSUInteger const kwCWaitingAnimationMinCount = 8;
NSUInteger const kWCWaitingAnimationFirstImageCount = 10;

NSString *const   kWCAnimationNameCircle = @"moveTheSquare";
NSString *const   kWCAnimationNameAlpha  =@"changeAlpha";

static WCWaitingViewController *_sharedWaitingViewController;

@interface WCWaitingViewController ()

@end

@implementation WCWaitingViewController

+(WCWaitingViewController*)sharedController
{
    if(_sharedWaitingViewController == nil)
    {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _sharedWaitingViewController = [[WCWaitingViewController alloc] initWithDefaultNib];
        });
    }
    return _sharedWaitingViewController;
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
    
    [self initUIs];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showFirstAnimation];
}

#pragma mark - Inits
-(void)initUIs
{
    self.view.backgroundColor = [UIColor lightGreenColor];
    self.view.alpha = 1.0f;
    
    self.labelMessage.font = [UIFont wcFont_H1];
    self.labelMessage.numberOfLines = 0;
    self.labelMessage.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelMessage.textColor = [UIColor whiteColor];
    self.labelMessage.text = NSLocalizedString(@"Please wait...", nil);
    self.labelMessage.backgroundColor = [UIColor mainNavigationBarColor];
    
    self.spinner.alpha = 0.0f;
}

#pragma mark - Public
-(void)showErrorMessage
{
    self.stopAnimatingTeamLogos = YES;
    self.animationCount = kwCWaitingAnimationMinCount;
    self.spinner.alpha = 0.0f;
    
    self.labelMessage.text = NSLocalizedString(@"Unable to connect", nil);
    
    self.imageViewError.image = [UIImage imageNamed:@"error"];
    self.imageViewError.hidden = NO;
}


#pragma mark - Animation

-(void)showFirstAnimation
{
    self.spinner.alpha = 1.0f;
    [self.spinner startAnimating];
    [self showFirstAnimationWithIndex:  [NSNumber numberWithInteger:0]];
}

-(void)showFirstAnimationWithIndex: (NSNumber*) numIndex
{
    NSUInteger cellIndex = [numIndex integerValue];
    
    if(cellIndex>= kWCWaitingAnimationFirstImageCount)
    {
        self.firstAnimationFinished = YES;
    }
    
    //array of image views.
    NSArray *imageViews = [self teamLogoImageViewsWithIndex: cellIndex];
    
    if(imageViews==nil)
    {
        return;
    }
    [UIView animateWithDuration: kWCAnimationDurationInSeconds3x
                          delay:0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         for(UIImageView *imageView in imageViews)
                         {
                             imageView.alpha = 1.0f;
                             imageView.frame = [self logoImageFrameStart];
                             imageView.layer.transform = CATransform3DIdentity;
                         }
                     }
                     completion:^(BOOL finished){
                         
                         if(finished)
                         {
                             [UIView animateWithDuration: kWCAnimationDurationInSeconds1x
                                              animations:^{
                                                  for(UIImageView *imageView in imageViews)
                                                  {
                                                      imageView.alpha = 0.0f;
                                                  }
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  if(finished)
                                                  {
                                                      for(UIImageView *imageView in imageViews)
                                                      {
                                                          [imageView removeFromSuperview];
                                                      }
                                                      
                                                     if(cellIndex>= kWCWaitingAnimationFirstImageCount)
                                                     {
                                                         [self showWaitingAnimation];
                                                     }
                                                  }
                                              }
                              ];
                         }
                     }];
 
    if(!self.firstAnimationFinished)
    {
        [self performSelector: @selector(showFirstAnimationWithIndex:)
                   withObject: [NSNumber numberWithInteger: cellIndex+1]
                    afterDelay:0.1f];
    }
}

-(void)showWaitingAnimation
{
    if(self.firstAnimationFinished)
    {
        [self showTeamLogoWithIndex: [NSNumber numberWithInteger:0]];
    }
    else
    {
        [self performSelector:@selector(showWaitingAnimation) withObject:nil afterDelay:0.5f];
    }
}

- (void) animateCicleAlongPath:(UIView *)view {
    
    CGFloat duration = 2.5f;
    
    //Prepare the animation - use keyframe animation for animations of this complexity
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration =duration;
    pathAnimation.autoreverses = NO;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = 1;
    

    
    CGFloat radius = 128.0f;
    CGFloat halfRadius = radius/2.0f;
    
    CGFloat centerX = view.center.x;
    CGFloat centerY = view.center.y;
    //Setup the path for the animation - this is very similar as the code the draw the line
    //instead of drawing to the graphics context, instead we draw lines on a CGPathRef
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, centerX,centerY );
    
    CGPathAddQuadCurveToPoint(curvedPath, NULL, centerX - halfRadius, centerY-halfRadius, centerX, centerY-radius);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, centerX + radius, centerY-radius, centerX+radius, centerY);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, centerX + radius, centerY+radius, centerX, centerY+radius);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, centerX-radius, centerY+radius, centerX-radius, centerY);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, centerX-radius*2.0f, centerY+ radius*2.0f, centerX-radius*3.0f, centerY+radius*2.0f);
  

    //Now we have the path, we tell the animation we want to use this path - then we release the path
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    //Add the animation to the circleView - once you add the animation to the layer, the animation starts
    [view.layer addAnimation:pathAnimation forKey: kWCAnimationNameCircle];
    pathAnimation.delegate = self;
    
    //alpha animations
    alphaAnimation.calculationMode = kCAAlignmentCenter;
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    alphaAnimation.duration = duration/2.0f;
    alphaAnimation.autoreverses = NO;
    //Lets loop continuously for the demonstration
    alphaAnimation.repeatCount = 1;
    alphaAnimation.delegate = self;
    
    NSArray *alphaValues = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat: 1.0f], nil];
    NSArray *times = [NSArray arrayWithObjects: [NSNumber numberWithFloat: 0.5f],
                      [NSNumber numberWithFloat: 0.5f],nil];
    [alphaAnimation setValues: alphaValues];
    [alphaAnimation setKeyTimes: times];
    
    [view.layer addAnimation:alphaAnimation forKey: kWCAnimationNameAlpha];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    
}

-(void)showTeamLogoWithIndex: (NSNumber*)numIndex
{
    if(self.stopAnimatingTeamLogos)
    {
        return;
    }
 
    NSUInteger teamIndex = [numIndex integerValue];
 
    //array of image views.
    NSArray *imageViews = [self teamLogoImageViewsWithIndex: teamIndex];
    
    if(imageViews==nil)
    {
        return;
    }
        [UIView animateWithDuration: kWCAnimationDurationInSeconds5x
                              delay:0.0f
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             for(UIImageView *imageView in imageViews)
                             {
                                 imageView.alpha = 1.0f;
                                 imageView.frame = [self logoImageFrameStart];
                                 imageView.layer.transform = CATransform3DIdentity;
                             }
                         }
                         completion:^(BOOL finished){
                             
                             if(finished)
                             {
                            
                                 [UIView animateWithDuration: kWCAnimationDurationInSeconds2x
                                                  animations:^{
                                                      for(UIImageView *imageView in imageViews)
                                                      {
                                                          imageView.alpha = 0.0f;
                                                      }
                                                  }
                                                  completion:^(BOOL finished){
                                                  
                                                      if(finished)
                                                      {
                                                          self.animationCount ++;
                                                          for(UIImageView *imageView in imageViews)
                                                          {
                                                              [imageView removeFromSuperview];
                                                          }
                                                      }
                                                  }
                                  ];
                             }
                         }];
  
    
    [self performSelector: @selector(showTeamLogoWithIndex:)
               withObject:[NSNumber numberWithInteger: teamIndex+1]
               afterDelay:0.2f];
    
}

-(NSArray*)teamLogoImageViewsWithIndex: (NSUInteger)teamIndex
{
    NSMutableArray *imageViews = [NSMutableArray array];
    NSArray *teams = [WCUserSettings allTeams];
    
    NSUInteger newIndex = teamIndex%teams.count - kWCWaitingImageViewsCountEachAnimation;
    
    
    for(NSUInteger viewIndex = 0; viewIndex< kWCWaitingImageViewsCountEachAnimation; viewIndex++)
    {
        if(newIndex+viewIndex >= teams.count)
        {
            break;
        }
        
        OneTeam *aTeam = [teams objectAtIndex: newIndex+viewIndex];
        UIImage *logoImage = [UIImage imageForTeam: aTeam.teamName];
        
        if(logoImage)
        {
            CGRect viewFrame = [self logoImageFrameEnd];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame: viewFrame];
            imageView.image = logoImage;
            imageView.alpha = 0.0f;
            imageView.layer.transform = CATransform3DMakeScale(2.0f, 2.0f, 1.0f);
            [self.view insertSubview: imageView belowSubview: self.labelMessage];
            
            [imageViews addObject: imageView];
        }
    }
    
    return imageViews;
}

-(void)startWaitingAnimation
{
    self.spinner.alpha = 1.0f;
    [self.spinner startAnimating];
    
    [self  showTeamLogoWithIndex: [NSNumber numberWithInteger:0]];
}

-(void)stopWaitingAnimation;
{
    if(!self.firstAnimationFinished)
    {
        [self performSelector:@selector(stopWaitingAnimation) withObject:nil afterDelay:0.5f];
        return;
    }
    
    self.stopAnimatingTeamLogos = YES;
    [self.spinner stopAnimating];
    
    [UIView animateWithDuration: kWCAnimationDurationInSeconds2x
                                   delay:0.0f
                                 options: UIViewAnimationOptionCurveEaseOut
                              animations:^{
                                  self.view.alpha = 0.0f;
                                  self.spinner.alpha = 0.0f;
                              } completion:^(BOOL finished){
                              
                                  if(finished)
                                  {
                                      [self.view removeFromSuperview];
                                  }
                              }];
}

#pragma mark - Propertie Values
-(CGRect)logoImageFrameStart
{
    CGFloat viewSize = kWCWaitingImageViewSize;
    
    CGRect viewFrame = CGRectMake(self.view.frame.size.width/2.0f - viewSize/2.0f,
                                  self.view.frame.size.height/2.0f - viewSize/2.0f,
                                  viewSize, viewSize );
    return viewFrame;
}

-(CGRect)logoImageFrameEnd
{
    NSInteger iFrag = arc4random()%10;
    if(iFrag%2 == 0)
    {
        return [self logoImageFrameEndBasedOnOriginX];
    }
    else
    {
        return [self logoImageFrameEndBasedOnOriginY];
    }
}

-(CGRect)logoImageFrameEndBasedOnOriginY
{
    CGFloat radius = 397.0f;
    
    CGFloat yOrigin =  arc4random()%((NSInteger)self.view.frame.size.height);
    
    CGFloat yRadius =self.view.frame.size.height/2.0f-yOrigin;
    CGFloat xRadius = sqrt(radius*radius - yRadius*yRadius);
    CGFloat xOrigin = self.view.frame.size.width/2.0f -xRadius;
    
    NSInteger iFlag = arc4random()%10;
    if(iFlag %2 == 0)
    {
        xOrigin = self.view.frame.size.width/2.0f +xRadius;
    }
    
    CGRect frameToReturn = CGRectMake(xOrigin, yOrigin, kWCWaitingImageViewSize, kWCWaitingImageViewSize);
 
    
    return  frameToReturn;
}

-(CGRect)logoImageFrameEndBasedOnOriginX
{
    CGFloat radius = 397.0f;
    
    CGFloat xOrigin =  arc4random()%((NSInteger)self.view.frame.size.width);
    
    CGFloat xRadius =self.view.frame.size.width/2.0f-xOrigin;
    CGFloat yRadius = sqrt(radius*radius - xRadius*xRadius);
    CGFloat yOrigin = self.view.frame.size.height/2.0f -yRadius;
    
    NSInteger iFlag = arc4random()%10;
    if(iFlag %2 == 0)
    {
        yOrigin = self.view.frame.size.height/2.0f +yRadius;
    }
    
    CGRect frameToReturn = CGRectMake(xOrigin, yOrigin, kWCWaitingImageViewSize, kWCWaitingImageViewSize);
    
    return  frameToReturn;
}

@end
