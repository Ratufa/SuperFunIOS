//
//  TermsCoditionsViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "TermsCoditionsViewController.h"
#import "Header.h"

@interface TermsCoditionsViewController ()<VSPRightPopUpDelegate,UITextViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) VSPRightPopUpView *popUp;

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
//Text View
@property (strong, nonatomic) IBOutlet UITextView *txtViewTerms;

@end

@implementation TermsCoditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    //[self localization];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidScroll:)];
    [_txtViewTerms addGestureRecognizer:recognizer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    _txtViewTerms.delegate =self;
    [self performSelectorOnMainThread:@selector(callWebserviceForGetTermsCondition) withObject:nil waitUntilDone:YES];
    
    if([[AppDelegate appDelegate].arrCacheTermsCondition count] == 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            _txtViewTerms.textAlignment=NSTextAlignmentJustified;
            _txtViewTerms.text = [ [AppDelegate appDelegate].arrCacheTermsCondition valueForKey:@"pp_english"] ;
        }
        else
        {
            _txtViewTerms.textAlignment=NSTextAlignmentRight;
            _txtViewTerms.text = [[AppDelegate appDelegate].arrCacheTermsCondition valueForKey:@"pp_arabic"];
        }
    }
    [self localization];
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
    }
    else
    {
        _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        // _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
    _lblScreenTitle.text = [MCLocalization stringForKey:@"Terms & Conditions"];
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForGetTermsCondition
{
    if ([MyUtility isInterNetConnection])
    {
        [MyUtility postMethodWithApiMethod:@"privacy_policy" Withparms:nil WithSuccess:^(id response)
         {
             
             [AppDelegate appDelegate].arrCacheTermsCondition=[response mutableCopy];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
             {
                 _txtViewTerms.textAlignment =NSTextAlignmentJustified;
                 _txtViewTerms.text = [response valueForKey:@"tos_english"] ;
             }
             else
             {
                 _txtViewTerms.textAlignment =NSTextAlignmentRight;
                 _txtViewTerms.text = [response valueForKey:@"tos_arabic"];
             }
         } failure:^(NSError *error)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([AppDelegate appDelegate].arrCacheTermsCondition.count == 0)
             {
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
             }
         }];
    }
    else
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please check your 'InterNet Connection'"],[MCLocalization stringForKey:@"Ok"])
    }
}
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

#pragma mark
#pragma mark -- VSPPopUpView Delegate
-(void)vSpRightPopUpDelegateMethod:(NSInteger)selectedIndex
{
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:4 andFromController:self];
    
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
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    //    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"signUp"]) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
    //    else{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
