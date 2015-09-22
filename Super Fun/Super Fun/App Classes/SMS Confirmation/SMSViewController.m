//
//  SMSViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 15/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "SMSViewController.h"



@interface SMSViewController ()<UIAlertViewDelegate>
{
    NSTimer *timer;
    int timerCount;
    UIAlertView *alertViewSMS;
}

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSeconds;
@property (strong, nonatomic) IBOutlet UILabel *lblMobileNo;
@property (strong, nonatomic) IBOutlet UILabel *lblAfterTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblRecieveSms;
@property (strong, nonatomic) IBOutlet UILabel *lblDidNotRecive;
@property (strong, nonatomic) IBOutlet UILabel *lblTimer;
@property (strong, nonatomic) IBOutlet UILabel *lblSecondsTitle;

//Text Field
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmCode;
@property (strong, nonatomic) IBOutlet UIButton *btnSendAgain;

@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@end

@implementation SMSViewController

#pragma mark
#pragma mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    timerCount = 180;
    _lblSeconds.text = @"180";
    // Do any additional setup after loading the view.
    
   // [_btnSendAgain setTitle:[MCLocalization stringForKey:@"Number is Correct"] forState:UIControlStateNormal];
    _lblMobileNo.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"];
    [self startTimer];
    //[self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localization];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
    [alertViewSMS dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark
#pragma mark -- Localization

-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _lblSecondsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _lblRecieveSms.font= [UIFont fontWithName:@"Helvetica-Bold" size:13];

    }
    else
    {
        _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
        _lblSecondsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblRecieveSms.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];

    }

    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Confirmation Code"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    _txtConfirmCode.attributedPlaceholder = str1;
    
    _lblScreenTitle.text = [MCLocalization stringForKey:@"SMS Code"];
    _lblRecieveSms.text = [MCLocalization stringForKey:@"A Verification Code will be sent to this number"];
    _lblTimer.text = [MCLocalization stringForKey:@"Timer"];
    _lblSecondsTitle.text = [MCLocalization stringForKey:@"Seconds"];
    _lblDidNotRecive.text = [MCLocalization stringForKey:@"Didn't recieve the SMS? ... Send Again"];
    [_btnConfirm setTitle:[MCLocalization stringForKey:@"Confirm"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark -- WebService Call
-(void)callWebServiceForEditNumber
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
        
        NSDictionary *dictParamertes = @{@"mob_no":_lblMobileNo.text,@"device_type":@"ios",@"device_id":deviceToken,@"uu_id":[MyUtility getUUIdofDevice],@"ipaddrss":[MyUtility getIPAddress],@"simno":@"985623741852963"};
        [MyUtility postMethodWithApiMethod:@"signup" Withparms:dictParamertes WithSuccess:^(id response)
         {
          if ([[response valueForKey:@"status"] isEqualToString:@"unsuccess"])
             {
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Number not exist"],[MCLocalization stringForKey:@"Ok"])
             }
             else
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"details"] forKey:@"user_info"];
             }
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
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
-(void)callWebServiceForConfirmTheCode
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
  
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];

        NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"id"],@"pin":_txtConfirmCode.text,@"device_id":deviceToken};
        
        [MyUtility postMethodWithApiMethod:@"verify_pin" Withparms:dictParamertes WithSuccess:^(id response)
         {
             
             if (![[response valueForKey:@"status"] isEqualToString:@"not verify"])
             {
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"details"] forKey:@"user_info"];
                 [[AppDelegate appDelegate]setRootViewController];
//                [MyUtility pushToViewController:(TabbarController.self) FromController:self WithIdentifier:@"TabbarController"];
                 
             }
             else
             {
                 _btnSendAgain.enabled = YES;
                ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Invalid! code"],[MCLocalization stringForKey:@"Ok"])
             }

            [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             
         }
        failure:^(NSError *error)
         {
             _btnSendAgain.enabled = YES;

             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
         }];
    }
    else
    {
        _btnSendAgain.enabled = YES;

        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
    }
}

#pragma mark
#pragma mark -- Timer Methods

- (void)increaseTimerCount
{
    _lblSeconds.text = [NSString stringWithFormat:@"%d", timerCount--];
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
     timerCount = 180;
    _btnSendAgain.enabled = YES;
    _lblAfterTimer.hidden = NO;
}

#pragma mark
#pragma mark -- UIButton Action Method

- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)btnSendAgainAction:(id)sender
//{
    
//    alertViewSMS = [[UIAlertView alloc] initWithTitle:[MCLocalization stringForKey:@"Super Fun"]
//                                                    message:[MCLocalization stringForKey:@"SuperFun will send an SMS text message to your number,Is your phone number correct?"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Edit"] otherButtonTitles:[MCLocalization stringForKey:@"Yes"], nil];
//    alertViewSMS.alertViewStyle = UIAlertViewStylePlainTextInput;
//    
//    [alertViewSMS textFieldAtIndex:0].text = _lblMobileNo.text;
//    
//    [[alertViewSMS textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
//    [alertViewSMS textFieldAtIndex:0].delegate = (id)self;
//     alertViewSMS.tag = 143;
//    [alertViewSMS show];
//}

- (IBAction)btnConfirmAction:(id)sender
{
    if (_txtConfirmCode.text.length>0)
    {
        _btnSendAgain.enabled = YES;
    [self performSelectorOnMainThread:@selector(callWebServiceForConfirmTheCode) withObject:nil waitUntilDone:YES];
    }
    else
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please insert confirmation code"],[MCLocalization stringForKey:@"Ok"])
    }
}

#pragma mark
#pragma mark -- UIAlertView Delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 143)
//    {
//        if (buttonIndex == 0)
//        {
//            NSString *telephoneNumber =  [alertView textFieldAtIndex:0].text ;
//            if ([MyUtility isBlankTextField:telephoneNumber])
//            {
//                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter mobile no."],[MCLocalization stringForKey:@"Ok"])
//            }
//            else if (![MyUtility isValideMobileNo:telephoneNumber])
//            {
//                ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter valid mobile number"],[MCLocalization stringForKey:@"Ok"])
//            }
//            else
//            {
//                if (![_lblMobileNo.text isEqualToString:telephoneNumber])
//                {
//                    _btnSendAgain.enabled = YES;
//                    _lblSeconds.text = @"120";
//                    [timer invalidate];
//                    timerCount = 120;
//                    _lblMobileNo.text = telephoneNumber;
//                    [self startTimer];
//                    
//                    [self performSelectorOnMainThread:@selector(callWebServiceForEditNumber) withObject:nil waitUntilDone:YES];
//                }
//            }
//        }
//    }
//}
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
