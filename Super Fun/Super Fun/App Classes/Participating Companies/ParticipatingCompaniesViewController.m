//
//  ParticipatingCompaniesViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "ParticipatingCompaniesViewController.h"
#import "Header.h"

@interface ParticipatingCompaniesViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,VSPRightPopUpDelegate>
{
    NSInteger iSelectedIndex;
}
@property (strong, nonatomic) VSPRightPopUpView *popUp;

//UIRefresh
@property (strong ,nonatomic) UIRefreshControl *refreshControl;
//Table View
@property (strong, nonatomic) IBOutlet UITableView *tblView;
//Label
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@end

@implementation ParticipatingCompaniesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //[self localization];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    // Do any additional setup after loading the view.
    [self performSelectorOnMainThread:@selector(callWebServiceForGetCompanyList) withObject:nil waitUntilDone:YES];
    
    if([ [AppDelegate appDelegate].arrCacheFunFairCenter count] == 0)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
    }
    else
    {
        [_tblView reloadData];
    }
    
    iSelectedIndex = -1;
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:130.0/255.0 blue:31.0/255.0 alpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                        action:@selector(callWebServiceForGetCompanyList)
              forControlEvents:UIControlEventValueChanged];
    [_tblView addSubview:_refreshControl];
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
        _lblScreenTitle.text = [MCLocalization stringForKey:@"Participating Companies"];
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
-(void)callWebServiceForGetCompanyList
{
    if ([MyUtility isInterNetConnection])
    {
        //[[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
        
        
        [MyUtility postMethodWithApiMethod:@"company_list" Withparms:nil WithSuccess:^(id response)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             [AppDelegate appDelegate].arrCacheFunFairCenter =[response mutableCopy];
             [_refreshControl endRefreshing];
             [_tblView reloadData];
             
         } failure:^(NSError *error)
         {
             [_refreshControl endRefreshing];
             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             ALERT_SHOW([MCLocalization stringForKey:@"Super Fun"], [MCLocalization stringForKey:@"Server connection! failed,please try again later"],[MCLocalization stringForKey:@"Ok"])
         }];
    }
    else
    {
        [_refreshControl endRefreshing];
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
    //   }
}
#pragma mark
#pragma mark -- UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppDelegate appDelegate].arrCacheFunFairCenter.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (iSelectedIndex == indexPath.row)
    {
        NSString *textList = nil;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            textList =[[[AppDelegate appDelegate].arrCacheFunFairCenter objectAtIndex:indexPath.row] objectForKey:@"branch_list_english"];
        }
        else
        {
            textList = [[[AppDelegate appDelegate].arrCacheFunFairCenter objectAtIndex:indexPath.row] objectForKey:@"branch_list_arabic"];
        }
        UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 10)];;
        NSData* data = [textList dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithData:data
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        txtView.attributedText = str;
        [txtView sizeToFit];
        
        if (textList.length == 0)
        {
            return 65;
        }
        else
        {
            return txtView.frame.size.height+58;
        }
    }
    else
    {
        return 65;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imgViewLogo = (UIImageView *)[cell viewWithTag:200];
    UIImageView *imgViewArrow = (UIImageView *)[cell viewWithTag:201];
    UILabel *lblCompanyName = (UILabel *)[cell viewWithTag:100];
    UILabel *lblBranches = (UILabel *)[cell viewWithTag:101];
    UILabel *lblBrancheTitle = (UILabel *)[cell viewWithTag:102];
    UITextView *textView = (UITextView *)[cell viewWithTag:400];
    
    NSDictionary *dictIndex = [[AppDelegate appDelegate].arrCacheFunFairCenter objectAtIndex:indexPath.row];
    
    imgViewLogo.clipsToBounds = YES;
    imgViewLogo.layer.cornerRadius = 7;
    [imgViewLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictIndex valueForKey:@"company_logo"]]] placeholderImage:[UIImage imageNamed:@"companies_placeholder"]];
    
    
    NSString *textList = nil;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        textList =[dictIndex valueForKey:@"branch_list_english"];
        lblCompanyName.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        lblBrancheTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:12];
        
    }
    else
    {
        lblCompanyName.font= [UIFont fontWithName:@"Helvetica-Bold" size:20];
        lblBrancheTitle.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        textList = [dictIndex valueForKey:@"branch_list_arabic"];
    }
    
    if (textList.length == 0)
    {
        imgViewArrow.hidden = YES;
    }
    else
    {
        imgViewArrow.hidden = NO;
    }
    if (indexPath.row == iSelectedIndex)
    {
        imgViewArrow.image = [UIImage imageNamed:@"upbutton"];
        textView.hidden = NO;
        
        NSData* data = [textList dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithData:data
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        textView.attributedText = str;
        textView.textAlignment = NSTextAlignmentCenter;
        //textView.text = lbl.text;
    }
    else
    {
        imgViewArrow.image = [UIImage imageNamed:@"downbutton"];
        textView.hidden = YES;
    }
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        lblCompanyName.text = [[dictIndex valueForKey:@"company_name"] capitalizedString];
    }
    else
    {
        lblCompanyName.text = [dictIndex valueForKey:@"arabic_name"];
    }
    lblBrancheTitle.text = [MCLocalization stringForKey:@"Branches"];
    lblBranches.text = [NSString stringWithFormat:@"%@",[dictIndex valueForKey:@"Number of branch"]];
    
    return cell;
}
#pragma mark
#pragma mark -- UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iSelectedIndex == indexPath.row)
    {
        iSelectedIndex = -1;
        [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    NSString *textList = nil;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        textList =[[[AppDelegate appDelegate].arrCacheFunFairCenter objectAtIndex:indexPath.row] objectForKey:@"branch_list_english"];
    }
    else
    {
        textList = [[[AppDelegate appDelegate].arrCacheFunFairCenter objectAtIndex:indexPath.row] objectForKey:@"branch_list_arabic"];
    }
    if (textList.length >0)
    {
        //User taps different  row.
        if (iSelectedIndex != -1)
        {
            NSIndexPath *prevPath = [NSIndexPath indexPathForRow:iSelectedIndex inSection:0];
            iSelectedIndex = indexPath.row;
            [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        //user tap new row with none expanded.
        iSelectedIndex = indexPath.row;
        [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:2 andFromController:self];
    
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
