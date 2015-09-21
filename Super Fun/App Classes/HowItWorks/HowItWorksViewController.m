//
//  HowItWorksViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "HowItWorksViewController.h"
#import "Header.h"

@interface HowItWorksViewController ()<UICollectionViewDataSource,UIScrollViewDelegate,VSPRightPopUpDelegate,UICollectionViewDelegate>

@property (strong, nonatomic) VSPRightPopUpView *popUp;

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
//CollectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collView;

@end

@implementation HowItWorksViewController

#pragma mark
#pragma mark -- View life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidScroll:)];
    [_collView addGestureRecognizer:recognizer];
    // Do any additional setup after loading the view.
    //  [self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    // Do any additional setup after loading the view.
    [self performSelectorOnMainThread:@selector(callWebServiceForHowItWorks) withObject:nil waitUntilDone:YES];
    
    if([ [AppDelegate appDelegate].arrCacheHowtoUse count] == 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
    }
    else
    {
        [_collView reloadData];
    }
    
}
#pragma mark
#pragma mark -- Localization
-(void)localization
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {    _lblScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:28];
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.text = [MCLocalization stringForKey:@"How to use the App?"];
    }
    else
    {
        _imgScreenTitle.hidden=NO;
        _lblScreenTitle.hidden=YES;
        //_lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
}
-(void)callWebServiceForHowItWorks
{
    if ([MyUtility isInterNetConnection])
    {
        
        NSString *language = @"arabic";
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            language = @"english";
        }
        NSDictionary *dictParamertes = @{@"type":language};
        [MyUtility postMethodWithApiMethod:@"howitworks" Withparms:dictParamertes WithSuccess:^(id response)
         {
             [AppDelegate appDelegate].arrCacheHowtoUse =[response mutableCopy];
             [_collView reloadData];
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
         }
                                   failure:^(NSError *error)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([AppDelegate appDelegate].arrCacheHowtoUse.count == 0)
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark
#pragma mark -- UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [AppDelegate appDelegate].arrCacheHowtoUse.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:200];
    
    [imgView setImageWithURL:[NSURL URLWithString:[[[AppDelegate appDelegate].arrCacheHowtoUse objectAtIndex:indexPath.row] objectForKey:@"img_url"]] placeholderImage:[UIImage imageNamed:@"how_it_box"]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_6_plus)
    {
        return CGSizeMake([[UIScreen mainScreen]bounds].size.width, 131);

    }
    else if (IS_IPHONE_6)
    {
        return CGSizeMake([[UIScreen mainScreen]bounds].size.width, 128);

    }
    else
    {
        return CGSizeMake([[UIScreen mainScreen]bounds].size.width, 123);

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
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:1 andFromController:self];
    
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
