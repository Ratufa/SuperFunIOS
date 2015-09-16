//
//  ContactUsViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Header.h"

@interface ContactUsViewController ()<VSPRightPopUpDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) VSPRightPopUpView *popUp;
//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHotLine;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblWebSite;
@property (strong, nonatomic) IBOutlet UILabel *lblWhatsApp;
@property (strong, nonatomic) IBOutlet UILabel *lblHotLineTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblEmailTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblWebSiteTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblWhatsAppTitle;
//View

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ContactUsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    //[self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
    [_scrollView addGestureRecognizer:recognizer];
    
    [self performSelectorOnMainThread:@selector(callWebserviceForContactUSInfo) withObject:nil waitUntilDone:YES];
    if ([AppDelegate appDelegate].dictCacheContact.count == 0)
    {
        _scrollView.hidden = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
    }
    else
    {
        _scrollView.hidden = NO;
        _lblEmail.text = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"email"];
        _lblHotLine.text = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"phone"];
        _lblWebSite.text = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"website"];
        _lblWhatsApp.text = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"whatsapp"];
    }
}
#pragma mark -- Hide Key Board on Collection View Touch
-(void)scrollViewTap:(UITapGestureRecognizer*)tapGesture
{
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _imgScreenTitle.hidden =YES;
        _lblScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _lblHotLineTitle.font= [UIFont fontWithName:@"Helvetica-Light" size:18];
        _lblEmailTitle.font= [UIFont fontWithName:@"Helvetica-Light" size:18];
        _lblWebSiteTitle.font= [UIFont fontWithName:@"Helvetica-Light" size:18];
        _lblWhatsAppTitle.font= [UIFont fontWithName:@"Helvetica-Light" size:18];
        
    }
    else
    {
        _imgScreenTitle.hidden =NO;
        _lblScreenTitle.hidden=YES;
        _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
        _lblHotLineTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblEmailTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblWebSiteTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblWhatsAppTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        
    }

    _lblScreenTitle.text = [MCLocalization stringForKey:@"CONTACT US"];
    _lblHotLineTitle.text = [MCLocalization stringForKey:@"Hot Line"];
    _lblEmailTitle.text = [MCLocalization stringForKey:@"Email"];
    _lblWebSiteTitle.text = [MCLocalization stringForKey:@"Web Site"];
    _lblWhatsAppTitle.text = [MCLocalization stringForKey:@"WhatsApp"];
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForContactUSInfo
{
    
    if ([MyUtility isInterNetConnection])
    {
        [MyUtility postMethodWithApiMethod:@"contact_us" Withparms:nil WithSuccess:^(id response)
         
         {
             _scrollView.hidden = NO;
             [AppDelegate appDelegate].dictCacheContact = [response mutableCopy];
             _lblEmail.text = [response valueForKey:@"email"];
             _lblHotLine.text = [response valueForKey:@"phone"];
             _lblWebSite.text = [response valueForKey:@"website"];
             _lblWhatsApp.text = [response valueForKey:@"whatsapp"];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             
         } failure:^(NSError *error)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([AppDelegate appDelegate].dictCacheContact.count== 0)
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


- (IBAction)actionHotLine:(id)sender {
    
    NSString *strLink = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"phone"];
    if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",strLink]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",strLink]]];
    }
    else{
         ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Call facility is not available"],[MCLocalization stringForKey:@"Ok"])
    }
}
- (IBAction)actionWebSite:(id)sender {
    
    NSString *strLink = [[AppDelegate appDelegate].dictCacheContact valueForKey:@"website"];
    if ([strLink.lowercaseString hasPrefix:@"http://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strLink]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",strLink]]];
    }
}
- (IBAction)actionWhatsApp:(id)sender {
//    
//    NSString *strLink = [_dicResponse valueForKey:@"whatsapp"];
////    NSURL *whatsAppURL = [NSURL URLWithString:@"http//:Whatsapp://location?id=1"];
////    
////    if ([[UIApplication sharedApplication] canOpenURL:whatsAppURL]) {
////        [[UIApplication sharedApplication] openURL:whatsAppURL];
////    }
//    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Hello%2C%20World!"];
//    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
//        [[UIApplication sharedApplication] openURL: whatsappURL];
//    }
//    else{
//    ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Error"],[MCLocalization stringForKey:@"Ok"])
//    }
}
- (IBAction)actionEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"basselalbayaa@gmail.com"]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else{
    ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(error)
    {
         ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Error"],[MCLocalization stringForKey:@"Ok"])
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark
#pragma mark -- VSPPopUpView Delegate
-(void)vSpRightPopUpDelegateMethod:(NSInteger)selectedIndex
{
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:6 andFromController:self];
    
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
