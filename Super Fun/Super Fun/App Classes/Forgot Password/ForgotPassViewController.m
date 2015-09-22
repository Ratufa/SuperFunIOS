//
//  ForgotPassViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 18/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "ForgotPassViewController.h"
#import "Header.h"

@interface ForgotPassViewController ()<UIAlertViewDelegate>

//Label

@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHeadingMobNo;
//Text Field
@property (strong, nonatomic) IBOutlet UITextField *txtMobNo;

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self localization];
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Mobile Number"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtMobNo.attributedPlaceholder = str1;
    
    _lblScreenTitle.text = [MCLocalization stringForKey:@"Forgot Password"];
    _lblHeadingMobNo.text = [MCLocalization stringForKey:@"Please enter your Mobile number"];
 
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmitAction:(id)sender
{
    if ([MyUtility isBlankTextField:_txtMobNo.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter mobile no."],[MCLocalization stringForKey:@"Ok"])
    }
    else
    {
        if ([MyUtility isInterNetConnection])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
            
            NSDictionary *dictParamertes = @{@"mob_no":_txtMobNo.text};
            
            [MyUtility postMethodWithApiMethod:@"forgot_password" Withparms:dictParamertes WithSuccess:^(id response)
             {
                 if ([[response valueForKey:@"status"] isEqualToString:@"failed"])
                 {
                     ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Mobile number or Password is wrong"],[MCLocalization stringForKey:@"Ok"])
                 }
                 else
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Password! has been sent to your mobile number through SMS,Please check"] delegate:nil cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                     alertView.tag = 143;
                     [alertView show];
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
#pragma mark
#pragma mark -- UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 143)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
