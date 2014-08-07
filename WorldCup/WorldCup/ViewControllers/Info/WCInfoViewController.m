//
//  WCInfoViewController.m
//  WorldCup
//
//  Created by XH Liu on 21/05/2014.
//  Copyright (c) 2014 XH Liu. All rights reserved.
//

#import "WCInfoViewController.h"
#import "WorldCup-Prefix.pch"
#import "WCMainMenuItem.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>


NSString *const kWCURLStringRateTheApp = @"itms-apps://itunes.apple.com/app/id887778603";
NSString *const kWCURLStringForSharingTheApp = @"https://itunes.apple.com/app/id887778603";

NSUInteger const kWCMoreInfoAlertRateTheApp = 555;

@interface WCInfoViewController ()

@end

@implementation WCInfoViewController

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
    
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    [self.mainMenuController updateTitle: NSLocalizedString(@"More", nil) ];
    [self.mainMenuController showPageIndicator:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inits
-(void )initTableView
{
    [self.tableView addBorderStyle];
}

#pragma mark - Actions
-(void)recommandTheAppTapped:(id)paramObject
{
    NSString *shareMsg =[NSString stringWithFormat:@"%@ %@",
                         NSLocalizedString(@"App Sharing Msg", nil),
                         kWCURLStringForSharingTheApp];
    UIImage *shareImage = [UIImage imageNamed: kWCImageNameForAppSharing];
    NSURL *shareUrl = [NSURL URLWithString: kWCURLStringForSharingTheApp];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareMsg, shareImage, shareUrl, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [self.rootController presentViewController:activityViewController animated:YES completion:nil];
}

-(void)rateTheAppTapped:(id)paramObject
{
    [self showAlertForRatingTheApp];
}

-(void)contactTheAppEamilTapped: (id)paramObject
{
    [self displayMailModalView];
}

-(void)contactTheAppFacebookTapped:(id)paramObject
{
    
}
-(void)contactTheAppTwitterTapped:(id)paramObject
{
    if(![SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter])
    {
        return;
    }
    
    SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
    
    [twitterController setInitialText: @"" ];
    
}


-(void)contactTheAppWeiboTapped:(id)paramObject
{
    
}

#pragma mark - Email
-(void)displayMailModalView
{
    if(![MFMailComposeViewController canSendMail])
    {
        return;
    }
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject:@"[World Cup App] Enquiry"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"info@xmartcalc.com"];
    NSArray *ccRecipients = [NSArray arrayWithObject:@"x_coder_20090203@hotmail.co.uk"];
    NSArray *bccRecipients = nil;
    
    [mailController setToRecipients:toRecipients];
    [mailController setCcRecipients:ccRecipients];
    [mailController setBccRecipients:bccRecipients];
    
    // Fill out the email body text
    NSString *emailBody = @"\n";
    [mailController setMessageBody:emailBody isHTML:NO];
    
    [self.rootController presentViewController: mailController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    BOOL hasError = YES;
    NSString *errorMessage=@"Email not sent";
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            errorMessage= @"Email canceled";
            hasError = NO;
            break;
        case MFMailComposeResultSaved:
            errorMessage = @"Email saved";
            hasError = NO;
            break;
        case MFMailComposeResultSent:
            hasError = NO;
            break;
        case MFMailComposeResultFailed:
            errorMessage = @"Email failed";
            break;
        default:
            errorMessage = @"Email not sent";
            break;
    }
    [self.rootController dismissViewControllerAnimated:YES completion:nil];
    
    if(hasError)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Alert View
-(void) showAlertForRatingTheApp
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Rate the app", nil)
                                                    message:NSLocalizedString(@"You are about to leave this app.", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel",nil)
                                          otherButtonTitles:NSLocalizedString(@"OK",nil), nil ];
    alert.tag = kWCMoreInfoAlertRateTheApp;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == kWCMoreInfoAlertRateTheApp)
    {
        //cancel
        if (buttonIndex == 0)
        {
            return;
        }
        //OK
        else
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: kWCURLStringRateTheApp]];
        }
    }
}

#pragma mark - UITableView Delegate & Data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = [WCMainMenuItem moreMenuItems].count;
    
    return rowsCount;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
  
    return sections;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWCOneTeamCellHeight*1.2f;
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: [self cellIdentityForTableView:tableView]];
    
    if(cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: [self cellIdentityForTableView: tableView]];
    }
    
    //init the cell
    cell.textLabel.font = [UIFont wcFont_H2];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor mainTextColor];
    
    NSArray *menuItems = [WCMainMenuItem moreMenuItems];
    WCMainMenuItem *aMenuItem = [menuItems objectAtIndex: indexPath.row];
    [self updateCellDataWithItem: aMenuItem forCell:cell];
    
    return cell;
}


-(void)updateCellDataWithItem:(WCMainMenuItem*)menuItem forCell: (UITableViewCell*)targetCell
{
    targetCell.imageView.image = [UIImage imageNamed: menuItem.imageName];
    targetCell.textLabel.text = NSLocalizedString( menuItem.title, nil);
}



-(NSString*)cellIdentityForTableView: (UITableView*)tableView
{
    NSString * cellID = @"MoreMenuCell";
    
    return cellID;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //find the control class
    WCMainMenuItem *aMenuItem = [[WCMainMenuItem moreMenuItems] objectAtIndex: indexPath.row];
    NSString *className = aMenuItem.controllerClassName;
    id ControlClass = NSClassFromString(className);
    id testObject = [[ControlClass alloc] init];
    
    if([testObject isKindOfClass: [WCBaseViewController class]])
    {
        WCBaseViewController *vController = [[ControlClass alloc]initWithDefaultNib];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vController];
        [vController addCloseButtonToNavigationBar];
        
        [self.rootController presentViewController: navController
                                          animated:YES
                                        completion:nil ];
        
    }
    //this is a selector
    else
    {
        SEL action = NSSelectorFromString( className);
        if([self respondsToSelector: action])
        {
            [self performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
    
    //un-select the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
