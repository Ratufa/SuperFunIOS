//
//  SignUpViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "SignUpViewController.h"
#import "Header.h"

@interface SignUpViewController ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;

//Label
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;

//Button
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
//Text Field
@property (strong, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPass;
@property (strong, nonatomic) IBOutlet UILabel *lblIAgreeTsPp;

@end

@implementation SignUpViewController

#pragma mark
#pragma mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _btnSignUp.titleLabel.font = [UIFont fontWithName:@"Moga_Magdy Soleman" size:17];

    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtPassword.attributedPlaceholder = str2;
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Confirm Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtConfirmPass.attributedPlaceholder = str3;
   // [self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localization];
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    
// Check FontFamily Avileble in Application
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
//
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _lblIAgreeTsPp.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _btnSignUp.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    }
    else
    {    _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        //_lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy Soleman" size:30];
        _lblIAgreeTsPp.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _btnSignUp.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];

    }
  //_lblScreenTitle.text = [MCLocalization stringForKey:@"Sign Up"];
    _lblScreenTitle.text = [MCLocalization stringForKey:@"WEL-COME"];
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:188.0/255.0 green:176.0/255.0 blue:116.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    _txtMobileNo.attributedPlaceholder = str1;
    
    _lblIAgreeTsPp.text = [MCLocalization stringForKey:@"A Verification Code will be sent to this number"];
    [_btnSignUp setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
}

#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnTermsCondition:(id)sender
{
    TermsCoditionsViewController *objTermsCoditionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsCoditionsViewController"];
    
    
    [self.navigationController pushViewController:objTermsCoditionsViewController animated:YES];
}
- (IBAction)btnPrivacyPolicy:(id)sender
{
    PrivacyPolicyViewController *objPrivacyPolicyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyPolicyViewController"];
    [self.navigationController pushViewController:objPrivacyPolicyViewController animated:YES];
}

- (IBAction)btnSignUpAction:(id)sender
{
    if ([MyUtility isBlankTextField:_txtMobileNo.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter mobile no."],[MCLocalization stringForKey:@"Ok"])
    }
    else if (![MyUtility isValideMobileNo:_txtMobileNo.text])
    {
         ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter valid mobile number"],[MCLocalization stringForKey:@"Ok"])
    }
//    else if ([MyUtility isBlankTextField:_txtPassword.text])
//    {
//        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter password"],[MCLocalization stringForKey:@"Ok"])
//    }
//    else if ([MyUtility isBlankTextField:_txtConfirmPass.text])
//    {
//        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please re-enter password"],[MCLocalization stringForKey:@"Ok"])
//    }
//    else if (![_txtPassword.text isEqualToString:_txtConfirmPass.text])
//    {
//        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Password mis-match"],[MCLocalization stringForKey:@"Ok"])
//    }
    else
    {
        UIAlertView *alertViewSMS
        = [[UIAlertView alloc] initWithTitle:[MCLocalization stringForKey:@"Super Fun"]
                                     message:[MCLocalization stringForKey:@"SuperFun will send an SMS text message to your number,Is your phone number correct?"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"No"] otherButtonTitles:[MCLocalization stringForKey:@"Yes"], nil];
        
//         alertViewSMS.alertViewStyle = UIAlertViewStylePlainTextInput;
       // NSString *strTemp = _txtMobileNo.text;
        //[[alertViewSMS textFieldAtIndex:1]setText:strTemp];
//        [[alertViewSMS textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
//        [alertViewSMS textFieldAtIndex:0].delegate = (id)self;
        alertViewSMS.tag = 143;
        [alertViewSMS show];
        }
    }
#pragma mark
#pragma mark -- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
    {
        if (alertView.tag == 143)
        {
           if (buttonIndex == 1)
            {
                if ([MyUtility isInterNetConnection])
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
                    NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];

                    NSDictionary *dictParamertes = @{@"mob_no":_txtMobileNo.text,@"device_type":@"ios",@"device_id":deviceToken,@"uu_id":[MyUtility getUUIdofDevice],@"ipaddrss":[MyUtility getIPAddress],@"simno":@"985623741852963"};
                    [MyUtility postMethodWithApiMethod:@"signup" Withparms:dictParamertes WithSuccess:^(id response)
                     {
                         //            if ([[response valueForKey:@"status"] isEqualToString:@"Already Registered"])
                         //                  {
                         //                      [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"details"] forKey:@"user_info"];
                         //
                         //                      SMSViewController *SMSViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SMSViewController"];
                         //
                         //                      [self.navigationController pushViewController:SMSViewController animated:YES];
                         //                    }
                         if ([[response valueForKey:@"status"] isEqualToString:@"unsuccess"])
                         {
                             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Number not exist"],[MCLocalization stringForKey:@"Ok"])
                         }
                         else if ([[response valueForKey:@"status"] isEqualToString:@"Already Login"])
                         {
                             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please logout from other device"],[MCLocalization stringForKey:@"Ok"])
                             
                         }
                         else if ([[response valueForKey:@"status"] isEqualToString:@"Not Verified Yet"])
                         {
                             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Your account is inactive now"],[MCLocalization stringForKey:@"Ok"])
                         }
                         else
                         {
                             [[NSUserDefaults standardUserDefaults]setObject:[response valueForKey:@"details"] forKey:@"user_info"];
                             [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"signUp"];
                            
                             SMSViewController *SMSViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SMSViewController"];
                             [self.navigationController pushViewController:SMSViewController animated:YES];
                             
                             // [MyUtility pushToViewController:(SMSViewController.self) FromController:self WithIdentifier:@"SMSViewController"];
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
