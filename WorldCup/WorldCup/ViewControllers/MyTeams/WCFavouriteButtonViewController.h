//
//  WCFavouriteButtonViewController.h
//  WorldCup
//
//  Created by XH Liu on 30/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCBaseViewController.h"

@interface WCFavouriteButtonViewController : WCBaseViewController

@property(nonatomic, strong)IBOutlet UIImageView  *backgroundView;
@property(nonatomic, strong) IBOutlet UIImageView *selectedImageView;
@property(nonatomic, strong) IBOutlet UIButton *buttonMain;

-(void)showSelectedImage: (BOOL)selected;

-(IBAction)mainButtonTapped:(id)sender;


@end
