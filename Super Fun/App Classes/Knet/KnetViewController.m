//
//  KnetViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 18/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "KnetViewController.h"
#import "Header.h"

@interface KnetViewController ()<UIWebViewDelegate>

//WebView
@property (strong, nonatomic) IBOutlet UIWebView *webViewKnet;
//Activity Indicator
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation KnetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:_paymentUrl];
    //  [_webViewKnet stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"<script>alert(\"%@\");</script>",[[response valueForKey:@"payment"] valueForKey:@"PaymentURL"]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webViewKnet loadRequest:request];

    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    _lblTitle.text=[MCLocalization stringForKey:@"Payment Gateway"];

   // [self performSelectorOnMainThread:@selector(callWebserviceForKnet) withObject:nil waitUntilDone:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _imgScreenTitle.hidden=YES;
    }
    else
    {
        _imgScreenTitle.hidden=NO;
        _lblTitle.hidden=YES;
        //_lblTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
}

/*
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForKnet
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        
        NSDictionary *dictParamertes = @{@"Mobile":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"Quantity":_amout,@"tickets":_ticket,@"points":_point};
        
        [MyUtility postMethodWithApiMethod:@"payment_request" Withparms:dictParamertes WithSuccess:^(id response)
         {
             if ([[response valueForKey:@"data"] isEqualToString:@"successful"])
             {
                 NSURL *url = [NSURL URLWithString:[[response valueForKey:@"payment"] valueForKey:@"PaymentURL"]];
               //  [_webViewKnet stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat: @"<script>alert(\"%@\");</script>",[[response valueForKey:@"payment"] valueForKey:@"PaymentURL"]]];

                 NSURLRequest *request = [NSURLRequest requestWithURL:url];
                 [_webViewKnet loadRequest:request];
                 
             }
             else
             {
                  ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Mobile number or Password is wrong"],[MCLocalization stringForKey:@"Ok"])
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
 */
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBackAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark
#pragma mark -- UIWebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
  //  [_activityIndicator startAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  //  [_activityIndicator stopAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   // [_activityIndicator stopAnimating];
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
