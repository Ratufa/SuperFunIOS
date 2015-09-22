//
//  TabbarController.h
//  ScratchMyApp
//
//  Created by Vivek on 10/10/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BuyTicketsViewController.h"
#import "HistoryViewController.h"
#import "CollectViewController.h"
#import <Foundation/Foundation.h>
#import "MyUtility.h"

@interface TabbarController : UITabBarController<UITabBarControllerDelegate,UITabBarDelegate>

@property (strong ,nonatomic) BuyTicketsViewController *buyCont;
@property (strong ,nonatomic) CollectViewController *collCont;
@property (strong ,nonatomic) HistoryViewController *historyCont;

@property (strong, nonatomic) UIButton *button0;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UIButton *button3;
@property (strong, nonatomic) UIButton *button4;
@property (strong, nonatomic) UIButton *button5;
@property (strong, nonatomic) UIView *viewForTabs;

@property (strong, nonatomic) UITabBarController *tabController;
@property (strong, nonatomic) UINavigationController *navSelected;

@property (strong, nonatomic) UINavigationController *navBuy ;
@property (strong, nonatomic) UINavigationController *navCont;
@property (strong, nonatomic) UINavigationController *navHistory ;


-(void)tabBarClick:(UIButton *)sender;

//@property (strong, nonatomic)UIView *viewForTabs;
@property (strong, nonatomic)UIImageView *imageViewForTabs;


@end
