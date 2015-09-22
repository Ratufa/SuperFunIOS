//
//  TabbarController.m
//  ScratchMyApp
//
//  Created by Vivek on 10/10/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//



#import "TabbarController.h"
#import "Header.h"

@interface TabbarController ()

@end

@implementation TabbarController
@synthesize imageViewForTabs,button0,button1,button2,button3,button4,button5,viewForTabs;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_tabController = [[UITabBarController alloc]init];
    [_tabController setDelegate:self];
    [_tabController.tabBar setTranslucent:YES];
    self.hidesBottomBarWhenPushed = YES;
    
    [self createCustomTabbar];
    
       _buyCont = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BuyTicketsViewController"];
    
      _collCont = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CollectViewController"];
    
       _historyCont = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"HistoryViewController"];
    
    _navBuy = [[UINavigationController alloc]initWithRootViewController:_buyCont];
    _navBuy.navigationBarHidden = YES;
    _navCont = [[UINavigationController alloc]initWithRootViewController:_collCont];
    _navCont.navigationBarHidden = YES;
    _navHistory = [[UINavigationController alloc]initWithRootViewController:_historyCont];
    _navHistory.navigationBarHidden = YES;
    _navSelected = _navBuy;
    
    NSArray *array = [[NSArray alloc]initWithObjects:_navBuy,_navCont,_navHistory,nil];
    self.viewControllers = array;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createCustomTabbar
{
    
    self.tabBar.hidden=YES;
    viewForTabs=[[UIView alloc ]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 100, self.view.frame.size.width, 100)];
    
    [viewForTabs setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewForTabs];
    
    button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button0 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [button0 setBackgroundColor:[UIColor clearColor]];
    button0.titleLabel.font = [UIFont fontWithName:@"Gabbaland" size:18];
    //[button0 setTitle:[MCLocalization stringForKey:@"Buy Tickets"] forState:UIControlStateNormal];
    [button0 setImage:[UIImage imageNamed:@"ticket_selected"] forState:UIControlStateSelected];
    [button0 setImage:[UIImage imageNamed:@"ticket_unselected"] forState:UIControlStateNormal];
    
//    if (IS_IPHONE_6_plus)
//    {
//        button0.titleEdgeInsets = UIEdgeInsetsMake(60,-80, 0, 0);
//        button0.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 17, 0);
//
//    }
//    else if (IS_IPHONE_6)
//    {
//        button0.titleEdgeInsets = UIEdgeInsetsMake(60,-80, 0, 0);
//        button0.imageEdgeInsets = UIEdgeInsetsMake(0, 26, 17, 0);
//
//    }
//    else
//    {
//        button0.titleEdgeInsets = UIEdgeInsetsMake(60,-80, 0, 0);
//        button0.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 17, 0);
//
//    }
    //    [button0 setTitleColor:[UIColor colorWithRed:234.0/255.0 green:232.0/255.0 blue:169.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    //    [button0 setTitleColor:[UIColor colorWithRed:236.0/255.0 green:127.0/255.0 blue:42.0/255.0 alpha:1.0] forState:UIControlStateSelected];
    //  [button0 setBackgroundImage:[UIImage imageNamed:@"page_indicator_strip"] forState:UIControlStateSelected];
    button0.frame = CGRectMake(0, 0,self.view.frame.size.width/3-0.5,100);
    button0.tag=0;

    
    [button0 setSelected:YES];

    [viewForTabs addSubview:button0];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.titleLabel.font = [UIFont fontWithName:@"Gabbaland" size:18];
    [button1 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(self.view.frame.size.width/3, 0,108,100);
     button1.tag=1;
     [button1 setBackgroundColor:[UIColor clearColor]];
    
    [button1 setImage:[UIImage imageNamed:@"collecting_unselected"] forState:UIControlStateNormal];
    
    [button1 setImage:[UIImage imageNamed:@"collecting_selected"] forState:UIControlStateSelected];
    
    [viewForTabs addSubview:button1];
    
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake((self.view.frame.size.width/3)*2, 0, self.view.frame.size.width/3.5, 100);
 

     button2.tag=2;
    [button2 setBackgroundColor:[UIColor clearColor]];
   
     [button2 setImage:[UIImage imageNamed:@"logbook_selected"] forState:UIControlStateSelected];
     [button2 setImage:[UIImage imageNamed:@"logbook_unselected"] forState:UIControlStateNormal];
    
    [viewForTabs addSubview:button2];
    
    if (IS_IPHONE_6_plus) {
        button0.frame = CGRectMake(0, 0,138,100);
        button1.frame = CGRectMake(self.view.frame.size.width/3, 0,138,100);
        button2.frame = CGRectMake((self.view.frame.size.width/3)*2, 0, 138, 100);
    }
    else if (IS_IPHONE_6)
    {
        button0.frame = CGRectMake(0, 0,125,100);
        button1.frame = CGRectMake(self.view.frame.size.width/3, 0,125,100);
        button2.frame = CGRectMake((self.view.frame.size.width/3)*2, 0, 125, 100);

    }
    else
    {
        button0.frame = CGRectMake(0, 0,107,100);
        button1.frame = CGRectMake(self.view.frame.size.width/3, 0,107,100);
        button2.frame = CGRectMake((self.view.frame.size.width/3)*2, 0,107, 100);

    }
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(160.5, 0, 52.5, 50);
    button3.tag=3;
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button3 setBackgroundColor:[UIColor blackColor]];
    [button3 setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    [button3 setImage:[UIImage imageNamed:@"delivery_food"] forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:12];
    //  [viewForTabs addSubview:button3];
    
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(214, 0, 52.5, 50);
    button4.tag=4;
    [button4 setImage:[UIImage imageNamed:@"booking_icon"] forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button4 setBackgroundColor:[UIColor blackColor]];
    [button4 setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    button4.titleLabel.font = [UIFont systemFontOfSize:12];
    //   [viewForTabs addSubview:button4];
    
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 addTarget:self action:@selector(tabBarClick:)
      forControlEvents:UIControlEventTouchUpInside];
    button5.frame = CGRectMake(267.5, 0, 52.5, 50);
    button5.tag=5;
    [button5 setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateSelected];
    [button5 setImage:[UIImage imageNamed:@"news_icon"] forState:UIControlStateNormal];
    [button5 setBackgroundColor:[UIColor blackColor]];
    //  [viewForTabs addSubview:button5];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.tabBarController.viewControllers = [[NSArray alloc]initWithObjects:_navBuy,_navCont,_navHistory,nil];
}

-(void)tabBarClick:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            
            _navSelected = _navBuy;
            [self setSelectedIndex:0];
            button0.selected = YES;
            button1.selected=NO;
            button2.selected=NO;
            button3.selected=NO;
            button4.selected=NO;
            button5.selected=NO;
            break;
        case 1:
            _navSelected = _navCont;

            [self setSelectedIndex:1];
            button0.selected = NO;
            button1.selected=YES;
            button2.selected=NO;
            button3.selected=NO;
            button4.selected=NO;
            button5.selected=NO;
            break;
        case 2:
            
            _navSelected = _navHistory;

            [self setSelectedIndex:2];
            button0.selected = NO;
            button1.selected=NO;
            button2.selected=YES;
            button3.selected=NO;
            button4.selected=NO;
            button5.selected=NO;
          
            break;
        case 3:
            
            [self setSelectedIndex:3];
            button0.selected = NO;
            button1.selected=NO;
            button2.selected=NO;
            button3.selected=YES;
            button4.selected=NO;
            button5.selected=NO;
          
            break;
        case 4:
     
            [self setSelectedIndex:4];
            button0.selected = NO;
            button1.selected=NO;
            button2.selected=NO;
            button3.selected=NO;
            button4.selected=YES;
            button5.selected=NO;
          
            break;
        case 5:

            [self setSelectedIndex:5];
            button0.selected = NO;
            button1.selected=NO;
            button2.selected=NO;
            button3.selected=NO;
            button4.selected=NO;
            button5.selected=YES;
         
            break;
    }
}

@end
