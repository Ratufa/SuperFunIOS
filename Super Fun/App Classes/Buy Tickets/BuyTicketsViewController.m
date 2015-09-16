//
//  BuyTicketsViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "BuyTicketsViewController.h"
#import "Header.h"

@interface BuyTicketsViewController ()<VSPRightPopUpDelegate,UIScrollViewDelegate,UITableViewDelegate>
{
    NSInteger iSelectedIndex;
}
//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMsg;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;

//VSPPopUpView
@property (strong, nonatomic) VSPRightPopUpView *popUp;

//Button
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;
//Array
@property (strong, nonatomic) NSMutableArray *arrayResponse;
//Table View
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation BuyTicketsViewController
#pragma Mark
#pragma Mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
    iSelectedIndex = -1;
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
        [objTabbarController.button2 setImage:[UIImage imageNamed:@"logbook_unsel_arabic"] forState:UIControlStateNormal];
    }
    
    [self performSelectorOnMainThread:@selector(callWebServiceForBuyTickets) withObject:nil waitUntilDone:YES];
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
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
}
-(void)callWebServiceForBuyTickets
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        // NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"]};
        [MyUtility postMethodWithApiMethod:@"pay_ticket_list" Withparms:nil WithSuccess:^(id response)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             _arrayResponse = [response valueForKey:@"detail"];
             
             [_tblView reloadData];
             
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
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblMsg.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _btnBuy.titleLabel.font = [UIFont fontWithName:@"Gabbaland" size:30];
    }
    else
    {
        _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        _lblMsg.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
        _btnBuy.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:26];
    }
    //    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Amount"] attributes:@{ NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    _lblScreenTitle.text = [MCLocalization stringForKey:@"Buy Games tickets"];
    _lblMsg.text = [MCLocalization stringForKey:@"Choose one of the  offers below"];
    [_btnBuy setTitle:[MCLocalization stringForKey:@"Buy"] forState:UIControlStateNormal];
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnBuyAction:(id)sender
{
    if (iSelectedIndex == -1)
    {
        ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Please select a offer"],[MCLocalization stringForKey:@"Ok"])
    }
    else
    {
        [self performSelectorOnMainThread:@selector(callWebserviceForKnet) withObject:nil waitUntilDone:YES];
    }
}
- (IBAction)btnHowItWorksAction:(id)sender
{
    
    HowItWorksViewController *howItWorksViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"HowItWorksViewController"];
    [self.navigationController pushViewController:howItWorksViewController animated:YES];
    // [MyUtility pushToViewController:(HowItWorksViewController.self) FromController:self WithIdentifier:@"HowItWorksViewController"];
    TabbarController *objTabbarController = (TabbarController *)self.tabBarController;
    objTabbarController.viewForTabs.hidden = YES;
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
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
#pragma mark -- Webservice Call
-(void)callWebserviceForKnet
{
    if ([MyUtility isInterNetConnection])
    {
        NSDictionary *dictTemp =  [_arrayResponse objectAtIndex:iSelectedIndex];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];

        NSDictionary *dictParamertes = @{@"Mobile":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"],@"Quantity":[dictTemp valueForKey:@"amount"],@"tickets":[dictTemp valueForKey:@"ticket"],@"points":[dictTemp valueForKey:@"point"],@"device_id":deviceToken};
        
        [MyUtility postMethodWithApiMethod:@"payment_request" Withparms:dictParamertes WithSuccess:^(id response)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([[response valueForKey:@"data"] isEqualToString:@"successful"])
             {
                 
                 KnetViewController *objKnetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KnetViewController"];
                 objKnetViewController.paymentUrl =[[response valueForKey:@"payment"] valueForKey:@"PaymentURL"];
                 [self.navigationController pushViewController:objKnetViewController animated:YES];
                 TabbarController *objTabbarController = (TabbarController *)self.tabBarController;
                 objTabbarController.viewForTabs.hidden = YES;
                 [_popUp hideRightPopUpView];
                 [self nilDropDownView];
             }
             else if ([[response valueForKey:@"data"] isEqualToString:@"Please login again"])
             {
                 
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Please login again"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 150;
                 return ;
             }
             else
             {
                 ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Mobile number or Password is wrong"],[MCLocalization stringForKey:@"Ok"])
             }
             
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
#pragma mark -- VSPPopUpView Delegate
-(void)vSpRightPopUpDelegateMethod:(NSInteger)selectedIndex
{
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:-1 andFromController:self];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    
}-(void)nilDropDownView
{
    _popUp = nil;
}
#pragma mark
#pragma mark -- UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayResponse.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *lblAmout = (UILabel *)[cell viewWithTag:100];
    UILabel *lblPoints = (UILabel *)[cell viewWithTag:102];
    UILabel *lblTickets = (UILabel *)[cell viewWithTag:104];
    UILabel *lblPrice= (UILabel *)[cell viewWithTag:101];
    UILabel *lblGiftPoints = (UILabel *)[cell viewWithTag:103];
    UILabel *lblTotalTickets = (UILabel *)[cell viewWithTag:105];
    UIButton *btnSelection = (UIButton *)[cell viewWithTag:300];
    UIImageView *imgViewbg = (UIImageView *)[cell viewWithTag:200];
    UIImageView *imgViewStrip1 = (UIImageView *)[cell viewWithTag:201];
    UIImageView *imgViewStrip2 = (UIImageView *)[cell viewWithTag:202];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        lblPrice.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
        lblGiftPoints.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
        lblTotalTickets.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    else
    {
        lblPrice.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblGiftPoints.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblTotalTickets.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
    }
    if (iSelectedIndex == indexPath.row)
    {
        [btnSelection setImage:[UIImage imageNamed:@"stripcircle_white"] forState:UIControlStateNormal];
        imgViewbg.hidden = NO;
        [imgViewStrip1 setImage:[UIImage imageNamed:@"strip_divideline"]];
        [imgViewStrip2 setImage:[UIImage imageNamed:@"strip_divideline"]];
        [lblPrice setTextColor:[UIColor whiteColor]];
        [lblGiftPoints setTextColor:[UIColor whiteColor]];
        [lblTotalTickets setTextColor:[UIColor whiteColor]];
        [lblAmout setTextColor:[UIColor blackColor]];
        [lblPoints setTextColor:[UIColor blackColor]];
        [lblTickets setTextColor:[UIColor blackColor]];
    }
    else
    {
        [lblPrice setTextColor:[UIColor colorWithRed:188.0/255.0 green:176.0/255.0 blue:116.0/255.0 alpha:1.0]];
        [lblGiftPoints setTextColor:[UIColor colorWithRed:188.0/255.0 green:176.0/255.0 blue:116.0/255.0 alpha:1.0]];
        [lblTotalTickets setTextColor:[UIColor colorWithRed:188.0/255.0 green:176.0/255.0 blue:116.0/255.0 alpha:1.0]];
        [lblAmout setTextColor:[UIColor colorWithRed:140.0/255.0 green:122.0/255.0 blue:58.0/255.0 alpha:1.0]];
        [lblPoints setTextColor:[UIColor colorWithRed:140.0/255.0 green:122.0/255.0 blue:58.0/255.0 alpha:1.0]];
        [lblTickets setTextColor:[UIColor colorWithRed:140.0/255.0 green:122.0/255.0 blue:58.0/255.0 alpha:1.0]];
        imgViewbg.hidden = YES;
        [imgViewStrip1 setImage:[UIImage imageNamed:@"divideline"]];
        [imgViewStrip2 setImage:[UIImage imageNamed:@"divideline"]];
        [btnSelection setImage:[UIImage imageNamed:@"stipcircle"] forState:UIControlStateNormal];
    }
    NSDictionary *dictIndex = [_arrayResponse objectAtIndex:indexPath.row];
    lblPrice.text = [MCLocalization stringForKey:@"Price K.D."];
    lblGiftPoints.text = [MCLocalization stringForKey:@"Gift Points"];
    lblTotalTickets.text = [MCLocalization stringForKey:@"Total Tickets"];
    lblAmout.text =[dictIndex valueForKey:@"amount"];
    lblPoints.text =[dictIndex valueForKey:@"point"];
    lblTickets.text =[dictIndex valueForKey:@"ticket"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    iSelectedIndex = indexPath.row;
    [_tblView reloadData];
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
