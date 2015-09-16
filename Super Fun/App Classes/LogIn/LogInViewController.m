//
//  LogInViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "LogInViewController.h"
#import "Header.h"

@interface LogInViewController ()

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;

@property (strong, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPass;
@property (strong, nonatomic) IBOutlet UILabel *lblNote;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // [self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localization];
    _btnLogIn.titleLabel.font = [UIFont fontWithName:@"Moga_Magdy Soleman" size:17];
    
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:188.0/255.0 green:176.0/255.0 blue:116.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    _txtMobileNo.attributedPlaceholder = str1;
    
    //    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithRed:<#(CGFloat)#> green:<#(CGFloat)#> blue:<#(CGFloat)#> alpha:<#(CGFloat)#>],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    //_txtPassword.attributedPlaceholder = str2;
    
    // _lblScreenTitle.text = [MCLocalization stringForKey:@"Log In"];
    //_lblScreenTitle.text = @"LOG IN";
    _lblScreenTitle.text = [MCLocalization stringForKey:@"LOG IN"];
    
    
    [_btnLogIn setTitle:[MCLocalization stringForKey:@"Log In"] forState:UIControlStateNormal];
    [_btnForgotPass setTitle:[MCLocalization stringForKey:@"Forgot Password?"] forState:UIControlStateNormal];
    _lblNote.text=[MCLocalization stringForKey:@"Note:This number need to be registered before A Verification Code will be sent to tnumberhis"];
    // _lblNote.text = @"Note:This number need to be registered before A Verification Code will be sent to this number";
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnForgotPasswordAction:(id)sender
{
    ForgotPassViewController *objForgotPass = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPassViewController"];
    [self.navigationController pushViewController:objForgotPass animated:YES];
}
- (IBAction)btnLogInAction:(id)sender
{
    
    if ([MyUtility isBlankTextField:_txtMobileNo.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter mobile no."],[MCLocalization stringForKey:@"Ok"])
    }
    
    else if (_txtMobileNo.text.length>8)
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please do not enter more than 8 digit number"],[MCLocalization stringForKey:@"Ok"])
    }
    //    else if ([MyUtility isBlankTextField:_txtPassword.text])
    //    {
    //        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter password"],[MCLocalization stringForKey:@"Ok"])
    //    }
    else
    {
        if ([MyUtility isInterNetConnection])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
            
            NSDictionary *dictParamertes = @{@"mob_no":_txtMobileNo.text,@"device_type":@"ios"};
            
            [MyUtility postMethodWithApiMethod:@"login" Withparms:dictParamertes WithSuccess:^(id response)
             {
                 if ([[response valueForKey:@"status"] isEqualToString:@"failed"])
                 {
                     ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Phone number is wrong"],[MCLocalization stringForKey:@"Ok"])
                 }
                 else if ([[response valueForKey:@"status"] isEqualToString:@"not verified yet"])
                 {
                     ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Phone number is not verified yet"],[MCLocalization stringForKey:@"Ok"])
                 }
                 else
                 {
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
                     
                     TabbarController *tabBarController =[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
                     [self.navigationController pushViewController:tabBarController animated:YES];
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
