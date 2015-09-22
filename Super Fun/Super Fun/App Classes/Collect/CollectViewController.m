//
//  CollectViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "CollectViewController.h"
#import "Header.h"

@interface CollectViewController ()<VSPRightPopUpDelegate>

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMobNo;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTickets;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblMobTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblNote;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTicketsTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPointsTitle;
//Scroll View
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;
//VSPPopUpView
@property (strong, nonatomic) VSPRightPopUpView *popUp;
//Button
@property (strong, nonatomic) IBOutlet UILabel *lblCollectTickets;
@property (strong, nonatomic) IBOutlet UILabel *lblCollectPoints;


@end

@implementation CollectViewController

#pragma mark
#pragma mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView.hidden = YES;


    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
    [_scrollView addGestureRecognizer:recognizer];
    _lblMobNo.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];

    [self localization];
    TabbarController *objTabbarController = (TabbarController *)self.tabBarController;
    objTabbarController.viewForTabs.hidden = NO;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        [objTabbarController.button0 setImage:[UIImage imageNamed:@"ticket_selected"] forState:UIControlStateSelected];
        [objTabbarController.button0 setImage:[UIImage imageNamed:@"ticket_unselected"] forState:UIControlStateNormal];
        [objTabbarController.button1 setImage:[UIImage imageNamed:@"collecting_selected"] forState:UIControlStateSelected];
        [objTabbarController.button1 setImage:[UIImage imageNamed:@"collecting_unselected"] forState:UIControlStateNormal];
        [objTabbarController.button2 setImage:[UIImage imageNamed:@"logbook_selected"] forState:UIControlStateSelected];
        [objTabbarController.button2 setImage:[UIImage imageNamed:@"logbook_unselected"] forState:UIControlStateNormal];
    }
    else
    {
        [objTabbarController.button0 setImage:[UIImage imageNamed:@"ticket_sel_arabic"] forState:UIControlStateSelected];
        [objTabbarController.button0 setImage:[UIImage imageNamed:@"ticket_unsel_arabic"] forState:UIControlStateNormal];
        [objTabbarController.button1 setImage:[UIImage imageNamed:@"collecting_sel_arabic"] forState:UIControlStateSelected];
        [objTabbarController.button1 setImage:[UIImage imageNamed:@"collecting_unsel_arabic"] forState:UIControlStateNormal];
        [objTabbarController.button2 setImage:[UIImage imageNamed:@"logbook_sel_arabic"] forState:UIControlStateSelected];
        [objTabbarController.button2 setImage:[UIImage imageNamed:@"logbook_unsel_arabic"] forState:UIControlStateNormal];    }
    
//    [objTabbarController.button0 setTitle:[MCLocalization stringForKey:@"Buy Tickets"] forState:UIControlStateNormal];
//    [objTabbarController.button1 setTitle:[MCLocalization stringForKey:@"Collecting"] forState:UIControlStateNormal];
//    [objTabbarController.button2 setTitle:[MCLocalization stringForKey:@"Log Book"] forState:UIControlStateNormal];
//    
    [self performSelectorOnMainThread:@selector(callWebserviceForCollect) withObject:nil waitUntilDone:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
#pragma mark
#pragma mark -- Hide Key Board on Collection View Touch
-(void)scrollViewTap:(UITapGestureRecognizer*)tapGesture
{
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblNote.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:23];
        _lblNote.font= [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _lblMobTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblTotalTicketsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblTotalPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblCollectPoints.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];

    }
    else
    {   _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        _lblNote.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
        _lblMobTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblTotalTicketsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:19];
        _lblTotalPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:19];
        _lblCollectPoints.font= [UIFont fontWithName:@"Helvetica-Bold" size:19];
    }
    _lblNote.text=[MCLocalization stringForKey:@"Show this page to the Cashier"];
    _lblScreenTitle.text = [MCLocalization stringForKey:@"Collecting Tickets & Points"];
    _lblMobTitle.text = [MCLocalization stringForKey:@"Mobile Number"];
    _lblTotalTicketsTitle.text = [MCLocalization stringForKey:@"Total Tickets"];
    _lblTotalPointsTitle.text = [MCLocalization stringForKey:@"Total Points"];
    _lblCollectTickets.text =[MCLocalization stringForKey:@"Collect Tickets"];
    _lblCollectPoints.text =[MCLocalization stringForKey:@"Collect Points"];
   
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForCollect
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
        

          NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"device_id":deviceToken};
        [MyUtility postMethodWithApiMethod:@"Ticket_Point_Info" Withparms:dictParamertes WithSuccess:^(id response)
         {
              [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([[response valueForKey:@"data"] isEqualToString:@"Please login again"])
             {
                 _scrollView.hidden = YES;
                 _lblTotalPoints.text = @"0";
                 _lblTotalTickets.text =@"0";
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Please login again"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 150;
                 return ;
             }
                 _scrollView.hidden = NO;
                 _lblTotalPoints.text = [response valueForKey:@"points_bal"];
                 _lblTotalTickets.text =[response valueForKey:@"tickets_bal"];

         }
        failure:^(NSError *error)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
         }];
    }
    else
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
    }
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnCollectTicketsAction:(id)sender
{
    if ([_lblTotalTickets.text integerValue]>0)
    {
        
    TicketsCollectViewController *objTicketsCollectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TicketsCollectViewController"];
    objTicketsCollectViewController.totalTickets = _lblTotalTickets.text;
    [self.navigationController pushViewController:objTicketsCollectViewController animated:YES];
        TabbarController *objTabbarController = (TabbarController *)self.tabBarController;
        objTabbarController.viewForTabs.hidden = YES;
        [_popUp hideRightPopUpView];
        [self nilDropDownView];

    }
    else{
     
    ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"You don't have enough ticket balance"],[MCLocalization stringForKey:@"Ok"])
    }

}
- (IBAction)btnCollectPointsAction:(id)sender
{
    if ([_lblTotalPoints.text integerValue]>0)
    {
        
    PointsCollectViewController *objPointsCollectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PointsCollectViewController"];
    objPointsCollectViewController.totalPoints = _lblTotalPoints.text;
    [self.navigationController pushViewController:objPointsCollectViewController animated:YES];
        TabbarController *objTabbarController = (TabbarController *)self.tabBarController;
        objTabbarController.viewForTabs.hidden = YES;
        [_popUp hideRightPopUpView];
        [self nilDropDownView];

    }
    else{
        
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"You don't have enough points balance"],[MCLocalization stringForKey:@"Ok"])
    }

}
- (IBAction)btnRightPopUpView:(id)sender
{
    if(_popUp == nil)
    {
        NSArray *arrayList = @[[MCLocalization stringForKey:@"Settings"],[MCLocalization stringForKey:@"How it Works?"],[MCLocalization stringForKey:@"Participating Companie"],[MCLocalization stringForKey:@"GIFTs LIST"],[MCLocalization stringForKey:@"Terms & Conditions"],[MCLocalization stringForKey:@"Privacy Policy"],[MCLocalization stringForKey:@"Contact Us"]];
        
        CGFloat height = 0;
        if ([arrayList count]>7)
        {
            height = 397;
        }
        else
        {
            if (IS_IPHONE_4)
            {
                height = ([arrayList count]* 40)-1;
            }
            else
            {
                height = ([arrayList count]* 48)-1;
            }
        }
        
        _popUp = [[VSPRightPopUpView alloc]showRightPopUpInView:self andWithButton:sender andWithHeight:height andWithArray:arrayList andWithScrollaleValue:NO andWithColor:[UIColor blackColor]];
        _popUp.delegate = self;
    }
    else
    {
        [_popUp hideRightPopUpView];
        [self nilDropDownView];
    }
}

#pragma mark
#pragma mark -- VSPPopUpView Delegate
-(void)vSpRightPopUpDelegateMethod:(NSInteger)selectedIndex
{
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:-1 andFromController:self];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
}
-(void)nilDropDownView
{
    _popUp = nil;
}
#pragma mark
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 150)
    {
        if ([MyUtility isInterNetConnection])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
            NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
            NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"device_id":deviceToken};
            [MyUtility postMethodWithApiMethod:@"logout" Withparms:dictParamertes WithSuccess:^(id response)
             
             {
                 if ([[response valueForKey:@"status"] isEqualToString:@"success"])
                 {
                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"signUp"];
                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user_info"];
                     [[AppDelegate appDelegate] setRootViewController];
                     
                 }
                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             }
                                       failure:^(NSError *error)
             {
                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"signUp"];
                 [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
                 [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user_info"];
                 [[AppDelegate appDelegate] setRootViewController];
             }];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"signUp"];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user_info"];
            [[AppDelegate appDelegate] setRootViewController];
            
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
