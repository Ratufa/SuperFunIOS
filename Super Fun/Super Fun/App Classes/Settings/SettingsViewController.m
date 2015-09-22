//
//  SettingsViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "SettingsViewController.h"
#import "Header.h"

@interface SettingsViewController ()<UIAlertViewDelegate,VSPRightPopUpDelegate>
@property (strong, nonatomic) VSPRightPopUpView *popUp;
//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblChooseLag;
@property (strong, nonatomic) IBOutlet UILabel *lblChangePassword;

//Text Field
@property (strong, nonatomic) IBOutlet UITextField *txtOldPass;
@property (strong, nonatomic) IBOutlet UITextField *txtNewPass;
@property (strong, nonatomic) IBOutlet UITextField *txtConfirmPass;

//Button
@property (strong, nonatomic) IBOutlet UIButton *btnEnglish;
@property (strong, nonatomic) IBOutlet UIButton *btnArabic;
@property (strong, nonatomic) IBOutlet UIButton *btnChange;
@property (strong, nonatomic) IBOutlet UIButton *btnLogOut;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"signUp"]) {
        _btnLogOut.hidden=NO;
    }
    else{
        _btnLogOut.hidden=YES;
    }
    _btnDelete.titleLabel.font = [UIFont fontWithName:@"Moga_Magdy-Soleman" size:17];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        [_btnArabic setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
        [_btnEnglish setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnArabic setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
        [_btnEnglish setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
    }
    
    [self localization];

}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {    _lblScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:28];
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.text = [MCLocalization stringForKey:@"SETTINGS"];
        [_btnSubmit setTitle:[MCLocalization stringForKey:@"Submit"]forState:UIControlStateNormal];
        _lblChooseLag.font =[UIFont fontWithName:@"Helvetica-Bold" size:18];
        _btnSubmit.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:20];
        _btnLogOut.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:20];
    }
    else
    {
        _imgScreenTitle.hidden=NO;
        _lblScreenTitle.hidden=YES;
         [_btnSubmit setTitle:[MCLocalization stringForKey:@"Submit"]forState:UIControlStateNormal];
        _lblChooseLag.font =[UIFont fontWithName:@"Helvetica-Bold" size:18];
        
        _btnSubmit.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:22];
        _btnLogOut.titleLabel.font =[UIFont fontWithName:@"Helvetica-Bold" size:20];
        
        //_lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Old Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtOldPass.attributedPlaceholder = str1;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"New Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtNewPass.attributedPlaceholder = str2;
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Confirm Password"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _txtConfirmPass.attributedPlaceholder = str3;
    
    _lblChooseLag.text = [MCLocalization stringForKey:@"Choose language"];
    _lblChangePassword.text = [MCLocalization stringForKey:@"Change Password"];

    [_btnChange setTitle:[MCLocalization stringForKey:@"Change"] forState:UIControlStateNormal];
    [_btnLogOut setTitle:[MCLocalization stringForKey:@"Log Out"] forState:UIControlStateNormal];
    [_btnDelete setTitle:[MCLocalization stringForKey:@"Delete My Account"]forState:UIControlStateNormal];
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForChangePassword
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        
        NSDictionary *dictParamertes = @{@"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"id"],@"old_pass":_txtOldPass.text,@"new_pass":_txtNewPass.text};
        [MyUtility postMethodWithApiMethod:@"change_password" Withparms:dictParamertes WithSuccess:^(id response)
         {
             if ([[response valueForKey:@"status"] isEqualToString:@"success"])
             {
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Password! changed successfuly"],[MCLocalization stringForKey:@"Ok"])
                 _txtOldPass.text = @"";
                 _txtNewPass.text = @"";
                 _txtConfirmPass.text = @"";
             }
             else
             {
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Old Password! not matched"],[MCLocalization stringForKey:@"Ok"])
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

#pragma mark
#pragma mark -- UIButton Action Method

- (IBAction)btnRightPopUpView:(id)sender
{
    if(_popUp == nil)
    {
        NSArray *arrayList = @[[MCLocalization stringForKey:@"Settings"],[MCLocalization stringForKey:@"How it Works?"],[MCLocalization stringForKey:@"Participating Companie"],[MCLocalization stringForKey:@"GIFTs LIST"],[MCLocalization stringForKey:@"Terms & Conditions"],[MCLocalization stringForKey:@"Privacy Policy"],[MCLocalization stringForKey:@"Contact Us"]];  CGFloat height = 0;
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

- (IBAction)btnBackAction:(id)sender
{
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"signUp"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
   // }
}
- (IBAction)btnEnglishAction:(id)sender
{
    //[MCLocalization sharedInstance].language = @"en";
    //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"english"];
    [_btnArabic setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
    [_btnEnglish setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
    _btnEnglish.selected=YES;
    //[self localization];
}
- (IBAction)btnArabicAction:(id)sender
{
    //[MCLocalization sharedInstance].language = @"ar";
    //[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"english"];
    [_btnArabic setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
    [_btnEnglish setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
    _btnArabic.selected=YES;
   // [self localization];
}

- (IBAction)btnSubmit:(id)sender
{
    if (_btnEnglish.selected==YES) {
        
        [MCLocalization sharedInstance].language = @"en";
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"english"];
        [_btnArabic setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
        [_btnEnglish setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
        [self localization];
        _btnEnglish.selected = NO;
    }
    else if(_btnArabic.selected == YES){
        [MCLocalization sharedInstance].language = @"ar";
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"english"];
        [_btnArabic setImage:[UIImage imageNamed:@"circle_blue_white"] forState:UIControlStateNormal];
        [_btnEnglish setImage:[UIImage imageNamed:@"circle_black_white"] forState:UIControlStateNormal];
        [self localization];
        _btnArabic.selected=NO;
    }

}
- (IBAction)btnChangeAction:(id)sender
{
    if ([MyUtility isBlankTextField:_txtOldPass.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter your old password"],[MCLocalization stringForKey:@"Ok"])
    }
    else if ([MyUtility isBlankTextField:_txtNewPass.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please enter your new password"],[MCLocalization stringForKey:@"Ok"])
    }
    else if ([MyUtility isBlankTextField:_txtConfirmPass.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please re-enter your new password"],[MCLocalization stringForKey:@"Ok"])
    }
    else if (![_txtNewPass.text isEqualToString:_txtConfirmPass.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Password mis-match"],[MCLocalization stringForKey:@"Ok"])
    }
    else if ([_txtOldPass.text isEqualToString:_txtNewPass.text])
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Password must differ from old password."],[MCLocalization stringForKey:@"Ok"])
    }
    else
    {
        [self performSelectorOnMainThread:@selector(callWebserviceForChangePassword) withObject:nil waitUntilDone:YES];
    }
}
- (IBAction)btnLogOutAction:(id)sender
{
    UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Do you want to log out"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"No"] otherButtonTitles:[MCLocalization stringForKey:@"Yes"], nil];
    alerView.tag = 144;
    [alerView show];
}
- (IBAction)btnDeleteMyAccount:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Are you sure,you want to delete account"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Cancel"] otherButtonTitles:[MCLocalization stringForKey:@"Ok"], nil];
    alertView.tag = 143;
    [alertView show];
}
#pragma mark
#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 144 && buttonIndex == 1)
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
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
             }];
        }
        else
        {
            ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
        }
        
    }
}// after animation

//#pragma mark
//#pragma mark -- UIAlertView Delegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
////    if (alertView.tag == 143 && buttonIndex == 1)
////    {
////        if ([MyUtility isInterNetConnection])
////        {
////            [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
////            
////            NSDictionary *dictParamertes = @{@"user_id":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"id"],@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"]};
////            [MyUtility postMethodWithApiMethod:@"delete_my_acount" Withparms:dictParamertes WithSuccess:^(id response)
////             
////             {
////                 if ([[response valueForKey:@"data"] isEqualToString:@"deleted"])
////                 {
////                     
////                     
////                     ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Delete Account successfuly"],[MCLocalization stringForKey:@"Ok"])
////                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
////                     [self.navigationController popToRootViewControllerAnimated:YES];
////                     
////                 }
////                 
////                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
////                 
////             }
////                                       failure:^(NSError *error)
////             {
////                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
////                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
////             }];
////        }
////        else
////        {
////            ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
////        }
////    }
//     if (alertView.tag == 144 && buttonIndex == 1)
//    {
//        if ([MyUtility isInterNetConnection])
//        {
//            [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
//            
//            NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"]};
//            [MyUtility postMethodWithApiMethod:@"logout" Withparms:dictParamertes WithSuccess:^(id response)
//             
//             {
//                 if ([[response valueForKey:@"status"] isEqualToString:@"success"])
//                 {
//                   //  ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Delete Account successfuly"],[MCLocalization stringForKey:@"Ok"])
//                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"signUp"];
//                     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLoggedIn"];
//                     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"user_info"];
//                     
//                     AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                     [appDelegate.mArrayStoreDateGiftList removeAllObjects];
//                     [appDelegate.arrCacheHowtoUse removeAllObjects];
//                     [appDelegate.arrCachePricy removeAllObjects];
//                     [appDelegate.arrCacheTermsCondition removeAllObjects];
//                     [appDelegate.arrCacheFunFairCenter removeAllObjects];
//
//                 }
//                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
//             }
//            failure:^(NSError *error)
//             {
//                 [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
//                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
//             }];
//        }
//        else
//        {
//            ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
//        }
//        
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark -- VSPPopUpView Delegate
-(void)vSpRightPopUpDelegateMethod:(NSInteger)selectedIndex
{
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:0 andFromController:self];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
}
-(void)nilDropDownView
{
    _popUp = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
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
