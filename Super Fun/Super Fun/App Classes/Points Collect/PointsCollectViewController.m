//
//  PointsCollectViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 18/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "PointsCollectViewController.h"
#import "Header.h"

@interface PointsCollectViewController ()<UIAlertViewDelegate>
{
    NSTimer *timer;
    NSInteger timerCount;
    BOOL isCallService;
}

//Label

@property (strong, nonatomic) IBOutlet UILabel *lblShowpage;
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMobNo;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirmationCode;
@property (strong, nonatomic) IBOutlet UILabel *lblSeconds;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPoints;
@property (strong, nonatomic) IBOutlet UILabel *lblMobTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPointsTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UILabel *lblConfirmationCodeTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblSecondsTitle;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PointsCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView.hidden = YES;
    
    //  _lblTotalPoints.text = _totalPoints;
    //_lblSeconds.text = @"30";
    //   timerCount = 30;
    
    // _lblMobNo.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"];
    // [self localization];
    // [self performSelectorOnMainThread:@selector(callWebserviceForCollectPoints) withObject:nil waitUntilDone:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    _lblTotalPoints.text = _totalPoints;
    _lblSeconds.text = @"30";
    timerCount = 30;
    _lblMobNo.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"];
    [self performSelectorOnMainThread:@selector(callWebserviceForCollectPoints) withObject:nil waitUntilDone:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setValueForPointsTimer) name:@"show_timer_points" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
    
    NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"confirmation_code":_lblConfirmationCode.text,@"operation":@"collect_point",@"device_id":deviceToken,@"timer_status":@"0"};
    [MyUtility postMethodWithApiMethod:@"timer_temp" Withparms:dictParamertes WithSuccess:^(id response)
     {
         
     }
                               failure:^(NSError *error)
     {
         
     }];
    isCallService = NO;
    [timer invalidate];
}
-(void)setValueForPointsTimer
{
    NSDate *bgDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateValue"];
    NSInteger seconds = [[NSDate date] timeIntervalSinceDate:bgDate];
    
    NSInteger newCount = timerCount - seconds;
    if (newCount<0)
    {
        timerCount = 0;
        _lblSeconds.text = @"0";
        [self stopTimer];
    }
    else
    {
        timerCount = newCount;
        _lblSeconds.text = [NSString stringWithFormat:@"%ld", (long)timerCount];
        
    }
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblShowpage.text =[MCLocalization stringForKey:@"Show this page to the Cashier"];
        
        _lblScreenTitle.text = [MCLocalization stringForKey:@"Points Collector"];
        
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _lblShowpage.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblMobTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblConfirmationCodeTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblSecondsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblTotalPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        
    }
    else
    {
        _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        //_lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
        _lblShowpage.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _lblMobTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblConfirmationCodeTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblSecondsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblTotalPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblShowpage.text =[MCLocalization stringForKey:@"Show this page to the Cashier"];
        
    }
    _lblScreenTitle.text = [MCLocalization stringForKey:@"Points Collector"];
    _lblMobTitle.text = [MCLocalization stringForKey:@"Mobile Number"];
    _lblConfirmationCodeTitle.text = [MCLocalization stringForKey:@"Confirmation Code"];
    _lblTimer.text = [MCLocalization stringForKey:@"Timer"];
    _lblSecondsTitle.text = [MCLocalization stringForKey:@"Seconds"];
    _lblTotalPointsTitle.text = [MCLocalization stringForKey:@"Total Points"];
    [_btnDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
}
#pragma mark
#pragma mark -- Timer Methods
- (void)increaseTimerCount
{
    _lblSeconds.text = [NSString stringWithFormat:@"%ld", (long)timerCount--];
    if (timerCount == -1)
    {
        [self stopTimer];
    }
}
- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
    
}
- (void)stopTimer
{
    [timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForCollectPoints
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
        
        NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"device_id":deviceToken};
        [MyUtility postMethodWithApiMethod:@"collect_point" Withparms:dictParamertes WithSuccess:^(id response)
         {
             
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             
             if ([[response valueForKey:@"data"] isEqualToString:@"Please login again"])
             {
                 _scrollView.hidden = YES;
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Please login again"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 150;
                 return ;
             }
             else if ([[response valueForKey:@"data"] isEqualToString:@"Point Short"])
             {
                 _scrollView.hidden = YES;
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Points are already collected"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 144;
                 
                 return;
             }
             else if ([[response valueForKey:@"message"] isEqualToString:@"Point allready collect"])
             {
                 _scrollView.hidden = YES;
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Points are already collected"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 144;
                 return;
             }
             _scrollView.hidden = NO;
             
             [self startTimer];
             isCallService = YES;
             _lblConfirmationCode.text = [response valueForKey:@"confirmation_code"];
             [self callWebServiceForTimer];
             
         } failure:^(NSError *error)
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
-(void)callWebServiceForTimer
{
    if ([MyUtility isInterNetConnection])
    {
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
        
        NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"confirmation_code":_lblConfirmationCode.text,@"operation":@"collect_point",@"device_id":deviceToken,@"timer_status":_lblSeconds.text};
        [MyUtility postMethodWithApiMethod:@"timer_temp" Withparms:dictParamertes WithSuccess:^(id response)
         {
             if ([[response valueForKey:@"data"] isEqualToString:@"fail"])
             {
                 if (isCallService)
                 {
                     [self callWebServiceForTimer];
                 }
             }
             else if ([[response valueForKey:@"data"] isEqualToString:@"Please login again"])
             {
                 _scrollView.hidden = YES;
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Please login again"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 150;
                 return ;
             }
             else if ([[response valueForKey:@"data"] isEqualToString:@"Point Short"])
             {
                 _scrollView.hidden = YES;
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Points are already collected"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 144;
                 
                 return;
             }
             else if ([[response valueForKey:@"message"] isEqualToString:@"Point allready collect"])
             {
                 _scrollView.hidden = YES;
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Points are already collected"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 144;
                 return;
             }
             else
             {
                 _scrollView.hidden = NO;
                 [timer invalidate];
                 
                 NSString *branchName = nil;
                 NSString *location = nil;
                 if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
                 {
                     branchName = [NSString stringWithFormat:@"%@ %@",[MCLocalization stringForKey:@"Branch name:"],[response valueForKey:@"detail"]];
                     location =  [NSString stringWithFormat:@"%@ %@",[MCLocalization stringForKey:@"Location:"],[response valueForKey:@"location_english"]];
                 }
                 else
                 {
                     branchName = [NSString stringWithFormat:@"%@ %@",[MCLocalization stringForKey:@"Branch name:"],[response valueForKey:@"detail_arabic"]];
                     location =  [NSString stringWithFormat:@"%@ %@",[MCLocalization stringForKey:@"Location:"],[response valueForKey:@"location_arabic"]];

                 }
                 
                 NSString *pointsCollected= [NSString stringWithFormat:@"%@ %@",[MCLocalization stringForKey:@"Points collected:"],_lblTotalPoints.text];
                 
                 NSString *combinedString = [NSString stringWithFormat:@"%@\n%@\n%@",pointsCollected,location,branchName];
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:combinedString delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 alertView.tag = 143;
                 [alertView show];
             }
         }
                                   failure:^(NSError *error)
         {
             if (isCallService)
             {
                 [self callWebServiceForTimer];
             }
         }];
    }
    else
    {
        if (isCallService)
        {
            [self callWebServiceForTimer];
        }
    }
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //   [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnDoneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
#pragma mark -- UIAlertView Delgate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 143 || alertView.tag == 144)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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
