//
//  HistoryViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "HistoryViewController.h"
#import "Header.h"
@interface HistoryViewController ()<UITabBarDelegate,VSPRightPopUpDelegate>
{
    NSInteger iSelectedIndex;
}
//UIRefresh
@property (strong ,nonatomic) UIRefreshControl *refreshControl;
//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
//VSPPopUpView
@property (strong, nonatomic) VSPRightPopUpView *popUp;
//TableView
@property (strong, nonatomic) IBOutlet UITableView *tblView;
//Array
@property (strong, nonatomic) NSMutableArray *arrayResponse;
@end

@implementation HistoryViewController

#pragma mark
#pragma mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:130.0/255.0 blue:31.0/255.0 alpha:1.0];
    _refreshControl.tintColor = [UIColor whiteColor];
    [_refreshControl addTarget:self
                            action:@selector(callWebserviceForGetPurchaseHistory)
                  forControlEvents:UIControlEventValueChanged];
    [_tblView addSubview:_refreshControl];
    
   // UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
   // [_tblView addGestureRecognizer:recognizer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self localization];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
    iSelectedIndex = -1;
    [self performSelectorOnMainThread:@selector(callWebserviceForGetPurchaseHistory) withObject:nil waitUntilDone:YES];
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
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
#pragma mark
#pragma mark -- Hide Key Board on Collection View Touch
-(void)scrollViewTap:(UITapGestureRecognizer*)tapGesture
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
        _lblScreenTitle.hidden=NO;
        _imgScreenTitle.hidden=YES;
        _lblScreenTitle.font= [UIFont fontWithName:@"Gabbaland" size:30];
    }
    else
    {
        _lblScreenTitle.hidden=YES;
        _imgScreenTitle.hidden=NO;
        _lblScreenTitle.font= [UIFont fontWithName:@"Moga_Magdy-Soleman" size:26];
    }
    _lblScreenTitle.text = [MCLocalization stringForKey:@"LOG BOOK"];
}
#pragma mark
#pragma mark -- Webservice Call
-(void)callWebserviceForGetPurchaseHistory
{
    
    if ([MyUtility isInterNetConnection])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:ShowMBProgressBar object:[MCLocalization stringForKey:@"Loading..."]];
       // NSDictionary *dictParamertes = @{@"mob_no":@"96566600805"};
        NSString *deviceToken = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"device_token"]];
  
        NSDictionary *dictParamertes = @{@"mob_no":[[[NSUserDefaults standardUserDefaults] valueForKey:@"user_info"] valueForKey:@"mob_no"], @"device_id":deviceToken};
        [MyUtility postMethodWithApiMethod:@"user_history" Withparms:dictParamertes WithSuccess:^(id response)
         {
             [_refreshControl endRefreshing];

             [[NSNotificationCenter defaultCenter]postNotificationName:HideMBProgressBar object:nil];
             if ([[response valueForKey:@"data"] isEqualToString:@"Please login again"])
             {
                 _tblView.hidden = YES;
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[MCLocalization stringForKey:@"Super Fun"] message:[MCLocalization stringForKey:@"Please login again"] delegate:self cancelButtonTitle:[MCLocalization stringForKey:@"Ok"] otherButtonTitles: nil];
                 [alertView show];
                 alertView.tag = 150;
                 return ;
             }
             else if ([[response valueForKey:@"status"] isEqualToString:@"fail"])
             {
                 _tblView.hidden = YES;
             }
             else if ([[response valueForKey:@"status"] isEqualToString:@"success"])
             {
                 _tblView.hidden = NO;
                 _arrayResponse = [response valueForKey:@"details"];
                 [_tblView reloadData];
             }
         }
    failure:^(NSError *error)
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
    [MyUtility pushSelectedIndexOfRightPopUp:selectedIndex andWithAlreadyOnViewIndex:-1 andFromController:self];
    
    [_popUp hideRightPopUpView];
    [self nilDropDownView];
}
-(void)nilDropDownView
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (iSelectedIndex == indexPath.row)
    {
        NSString *textList = nil;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            textList =[[_arrayResponse objectAtIndex:indexPath.row] objectForKey:@"operation_location"];
        }
        else
        {
            textList = [[_arrayResponse objectAtIndex:indexPath.row] objectForKey:@"operation_location"];
        }
        UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 10)];;
        NSData* data = [textList dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithData:data
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        
        
        txtView.attributedText = str;
        [txtView sizeToFit];
      // txtView.textAlignment =NSTextAlignmentCenter;
        if (textList.length == 0)
        {
            return 55;
        }
        else
        {
            return txtView.frame.size.height+58;
        }  
    }
    else
    {
        return 55;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"historyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imgViewArrow = (UIImageView *)[cell viewWithTag:201];
    UILabel *lblOperation = (UILabel *)[cell viewWithTag:100];
    UILabel *lblDate = (UILabel *)[cell viewWithTag:101];
    UILabel *lblOperationType = (UILabel *)[cell viewWithTag:102];
    UILabel *lblOperationValue = (UILabel *)[cell viewWithTag:103];
    UITextView *textView = (UITextView *)[cell viewWithTag:400];
  //  UIWebView *webView = (UIWebView *)[cell viewWithTag:500];
    NSDictionary *dictIndex = [_arrayResponse objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:[dictIndex valueForKey:@"date"]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy - hh:mm a"];
    lblDate.text = [dateFormatter2 stringFromDate:date];
    NSString *textList = nil;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        lblOperation.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
        lblOperationType.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];

        textList =[dictIndex valueForKey:@"operation_location" ];
        lblOperation.text = [dictIndex valueForKey:@"operation_name"];
        lblOperationType.text = [dictIndex valueForKey:@"operation_type"];
        lblOperationValue.text = [dictIndex valueForKey:@"operation_value"];
//        NSString *bodyHTML = [NSString stringWithFormat:@"<html>\n"
//                              "<head>\n"
//                              "<link href=\"style.css\" rel=\"stylesheet\" type=\"text/css\" /> \n"
//                              "</head> \n"
//                              "<body>%@</body> \n"
//                              "</html>",textList];
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"style" ofType:@"css"];
//        NSURL *baseURL = [NSURL fileURLWithPath:path];
//        [webView loadHTMLString:bodyHTML baseURL:baseURL];
    }
    else
    {  
        lblOperation.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
        lblOperationType.font= [UIFont fontWithName:@"Helvetica-Bold" size:14];
        textList = [dictIndex valueForKey:@"operation_location_arabic" ];
        lblOperationValue.text = [dictIndex valueForKey:@"operation_value_arabic"];
        lblOperation.text = [dictIndex valueForKey:@"operation_name_arabic"];
        lblOperationType.text = [dictIndex valueForKey:@"operation_type_arabic"];
//        NSString *bodyHTML = [NSString stringWithFormat:@"<html>\n"
//                              "<head>\n"
//                              "<link href=\"style Arabic.css\" rel=\"stylesheet\" type=\"text/css\" /> \n"
//                              "</head> \n"
//                              "<body>%@</body> \n"
//                              "</html>",textList];
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"style Arabic" ofType:@"css"];
//        NSURL *baseURL = [NSURL fileURLWithPath:path];
//        [webView loadHTMLString:bodyHTML baseURL:baseURL];
        //[webView.scrollView setShowsVerticalScrollIndicator:NO];
       // [webView.scrollView setShowsHorizontalScrollIndicator:NO];
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
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            textView.attributedText = str;
            textView.textAlignment = NSTextAlignmentCenter;
        }
        else{
            textView.attributedText = str;
            textView.textAlignment = NSTextAlignmentRight;
        }
    }
    else
    {
        imgViewArrow.image = [UIImage imageNamed:@"downbutton"];
        textView.hidden = YES;
    }
    
   //NSURL *htmlString = [[NSBundle mainBundle]  URLForResource: @"string"     withExtension:@"html"];
//    NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc] initWithFileURL:htmlString
//                                                                                       options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
//                                                                            documentAttributes:nil
//                                                                                         error:nil];
        
//        NSData* data = [textList dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithData:data
//                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
//                                                                                           NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//    
//    
//        textView.attributedText = str;
    
    return cell;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //[_popUp hideRightPopUpView];
//    //[self nilDropDownView];
//}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    [_popUp hideRightPopUpView];
    [self nilDropDownView];

}
//#pragma mark
//#pragma mark -- UITableView Delegate
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_popUp hideRightPopUpView];
[self nilDropDownView];

    if (iSelectedIndex == indexPath.row)
    {
        iSelectedIndex = -1;
        [_tblView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
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
