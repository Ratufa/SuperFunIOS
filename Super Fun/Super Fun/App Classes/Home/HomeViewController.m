//
//  HomeViewController.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<vSpDropDownDelegate>

//Label
@property (strong, nonatomic) IBOutlet UIImageView *imgScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblScreenTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblHowItsWork;
@property (strong, nonatomic) IBOutlet UILabel *lblParticipatingCompany;
@property (strong, nonatomic) IBOutlet UILabel *lblDoYouHaveAccount;
//Button
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnChangeLang;
@property (strong, nonatomic) IBOutlet UIButton *btnHowItUse;
@property (strong, nonatomic) IBOutlet UIButton *btnFunFair;

//Drop Down Object
@property (strong, nonatomic) VSPDropDownView *dropDown;
//Scroll View
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HomeViewController

#pragma mark
#pragma mark -- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

   // [MyUtility printFontNames];
    
    
    _btnLogIn.titleLabel.font = [UIFont fontWithName:@"Moga_Magdy-Soleman" size:17];
    _btnSignUp.titleLabel.font = [UIFont fontWithName:@"Moga_Magdy-Soleman" size:17];
   // _lblDoYouHaveAccount.font = [UIFont fontWithName:@"Moga_Magdy-Soleman" size:17];

    _btnHowItUse.titleLabel.textColor = [UIColor colorWithRed:246.0/255.0 green:130.0/255.0
                                                         blue:31.0/255.0 alpha:1.0];
    _btnFunFair.titleLabel.textColor = [UIColor colorWithRed:246.0/255.0 green:130.0/255.0
                                                         blue:31.0/255.0 alpha:1.0];
    _btnChangeLang.titleLabel.textColor = [UIColor colorWithRed:246.0/255.0 green:130.0/255.0
                                                         blue:31.0/255.0 alpha:1.0];


    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"])
    {
        TabbarController *tabBar = [self.storyboard  instantiateViewControllerWithIdentifier:@"TabbarController"];

        [self.navigationController pushViewController:tabBar animated:NO];
    }
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
    [_scrollView addGestureRecognizer:recognizer];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localization];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
     [_dropDown removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self nilDropDownView];
}

#pragma mark
#pragma mark -- Hide Key Board on Collection View Touch

-(void)scrollViewTap:(UITapGestureRecognizer*)tapGesture
{
    [_dropDown hideDropDown:_btnChangeLang];
    [self nilDropDownView];
}

#pragma mark
#pragma mark -- Localization

-(void)localization
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [style setLineSpacing:-5];
    
    UIFont *font1;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        if (IS_IPHONE_6_plus )
        {
            font1 = [UIFont fontWithName:@"Gabbaland" size:25];
        }
        else if (IS_IPHONE_6)
        {
            font1 = [UIFont fontWithName:@"Gabbaland" size:23];
 
        }
        else
        {
            font1 = [UIFont fontWithName:@"Gabbaland" size:20];
        }
        _lblDoYouHaveAccount.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];

    }
    else
    {
        font1 = [UIFont fontWithName:@"Gabbaland" size:16];
        _lblDoYouHaveAccount.font= [UIFont fontWithName:@"Helvetica-Bold" size:17];

    }
    
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),
                            NSFontAttributeName:font1,
                            NSParagraphStyleAttributeName:style};
    NSMutableAttributedString* attrStringHow = [[NSMutableAttributedString alloc]initWithString:[MCLocalization stringForKey:@"How to use"] attributes:dict1];
    NSMutableAttributedString* attrStringFun = [[NSMutableAttributedString alloc]initWithString:[MCLocalization stringForKey:@"Fun Fair Centers"] attributes:dict1];
    NSString *tempString = nil;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
    {
        tempString = @"English";
    }
    else
    {
        tempString = @"العربية";
    }
    
    NSMutableAttributedString* attrStringLag = [[NSMutableAttributedString alloc]initWithString:tempString attributes:dict1];
    
    [_btnHowItUse setAttributedTitle:attrStringHow forState:UIControlStateNormal];
    [_btnFunFair setAttributedTitle:attrStringFun forState:UIControlStateNormal];
    [_btnChangeLang setAttributedTitle:attrStringLag forState:UIControlStateNormal];
    [_btnLogIn setTitle:[MCLocalization stringForKey:@"Log In"] forState:UIControlStateNormal];
    [_btnSignUp setTitle:[MCLocalization stringForKey:@"Continue"] forState:UIControlStateNormal];
     _lblDoYouHaveAccount.text =[MCLocalization stringForKey:@"Please click below for Sign In/Sign Up"];
    //_lblDoYouHaveAccount.text = @"Don't have an Account..Sign Up now";
}

#pragma mark
#pragma mark -- Drop Down Delegate
-(void)vSpDropDownDelegateMethod:(UIButton *)sender
{
    NSInteger indexNo = sender.tag;
    if (indexNo == 0)
    {
        [MCLocalization sharedInstance].language = @"ar";
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"english"];
    }
    else
    {
        [MCLocalization sharedInstance].language = @"en";
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"english"];
    }
    [self localization];
    [self nilDropDownView];
}

-(void)nilDropDownView
{
    _dropDown = nil;
}
#pragma mark
#pragma mark -- UIButton Action Method
- (IBAction)btnHowItWorksAction:(id)sender
{
    HowItWorksViewController *howItWorksViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"HowItWorksViewController"];
    
    [self.navigationController pushViewController:howItWorksViewController animated:YES];
    
    //[MyUtility pushToViewController:(HowItWorksViewController.self) FromController:self WithIdentifier:@"HowItWorksViewController"];
}
- (IBAction)btnParticipatingCompaniesAction:(id)sender
{
    ParticipatingCompaniesViewController *participatingCompaniesViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"ParticipatingCompaniesViewController"];
    
    [self.navigationController pushViewController:participatingCompaniesViewController animated:YES];
    
   // [MyUtility pushToViewController:(ParticipatingCompaniesViewController.self) FromController:self WithIdentifier:@"ParticipatingCompaniesViewController"];
}

- (IBAction)btnChangeLanguageAction:(id)sender
{
    NSMutableArray * arrList = [[NSMutableArray alloc] initWithObjects:@"العربية",@"English", nil];
   
    if(_dropDown == nil)
    {
        CGFloat height = 0;
        if ([arrList count]>10)
        {
            height = 397;
        }
        else
        {
            height = ([arrList count]* 40)-3;
        }
            _dropDown = [[VSPDropDownView alloc]showDropDownInView:self andWithButton:_btnChangeLang andWithHeight:height andWithArray:arrList andWithDirection:@"down" andWithScrollaleValue:NO andWithColor:[UIColor colorWithRed:246.0/255.0 green:130/255.0 blue:31/255.0 alpha:1.0]];
            _dropDown.delegate = self;
    }
    else
    {
        [_dropDown hideDropDown:sender];
        [self nilDropDownView];
    }
    
}
- (IBAction)btnLogInAction:(id)sender
{
    
    LogInViewController *logInViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
    
    [self.navigationController pushViewController:logInViewController animated:YES];
    
    //[MyUtility pushToViewController:(LogInViewController.self) FromController:self WithIdentifier:@"LogInViewController"];
}
- (IBAction)btnSignUpAction:(id)sender
{
    SignUpViewController *signUpViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    [self.navigationController pushViewController:signUpViewController animated:YES];
    
   // [MyUtility pushToViewController:(SignUpViewController.self) FromController:self WithIdentifier:@"SignUpViewController"];
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
