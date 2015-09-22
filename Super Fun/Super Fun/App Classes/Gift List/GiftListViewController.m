//
//  GiftListViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "GiftListViewController.h"
#import "Header.h"
#import "AppDelegate.h"

@interface GiftListViewController ()<UITableViewDataSource,VSPRightPopUpDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) VSPRightPopUpView *popUp;

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
//Table
@property (strong, nonatomic) IBOutlet UITableView *tblViewGift;
@end

@implementation GiftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    // Do any additional setup after loading the view.
    
    if([[AppDelegate appDelegate].arrCacheGiftList count] == 0)
    {
        [self performSelectorOnMainThread:@selector(callWebServiceForGetGiftList) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [_tblViewGift reloadData];
    }
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        _lblScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.text = [MCLocalization stringForKey:@"Gifts List"];
    }
    else
    {
        _imgScreenTitle.hidden=NO;
        _lblScreenTitle.hidden=YES;
        //_lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
}
#pragma mark
#pragma mark -- Web service Class
-(void)callWebServiceForGetGiftList
{
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        
        [MyUtility postMethodWithApiMethod:@"gift_list" Withparms:nil WithSuccess:^(id response)
         {
             [AppDelegate appDelegate].arrCacheGiftList =[response mutableCopy];
             [_tblViewGift reloadData];
             
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             
         } failure:^(NSError *error)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([AppDelegate appDelegate].arrCacheGiftList.count == 0)
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
#pragma mark
#pragma mark -- UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppDelegate appDelegate].arrCacheGiftList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:200];
    UILabel *lblGiftName = (UILabel *)[cell viewWithTag:100];
    UILabel *lblPoints = (UILabel *)[cell viewWithTag:101];
    UILabel *lblWorth = (UILabel *)[cell viewWithTag:102];
    UILabel *lblPointsTitle = (UILabel *)[cell viewWithTag:103];
    NSDictionary  *dictIndex = [[AppDelegate appDelegate].arrCacheGiftList objectAtIndex:indexPath.row];
    lblWorth.text = [MCLocalization stringForKey:@"Worth"];
    lblPointsTitle.text = [MCLocalization stringForKey:@"Points"];
    
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = 7;
    [imgView setImageWithURL:[NSURL URLWithString:[dictIndex valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"image_box"]];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        lblPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:12];
        lblGiftName.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblGiftName.text = [[dictIndex valueForKey:@"english_name"] capitalizedString];
    }
    else
    {
        lblPointsTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
        lblGiftName.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];
        lblGiftName.text = [dictIndex valueForKey:@"arabic_name"];
    }
    lblPoints.text =[dictIndex valueForKey:@"worth_points"];
    return cell;
}

//Mark: -Memory Warning

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

- (IBAction)actionRightPopList:(id)sender {
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
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:3 andFromController:self];
    
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

@end
