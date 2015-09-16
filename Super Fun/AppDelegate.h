//
//  AppDelegate.h
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic)NSMutableArray *arrCacheGiftList;
@property(strong,nonatomic)NSMutableArray *arrCachePricy;
@property(strong,nonatomic)NSMutableArray *arrCacheTermsCondition;
@property(strong,nonatomic)NSMutableArray *arrCacheHowtoUse;
@property(strong,nonatomic)NSMutableArray *arrCacheFunFairCenter;
@property(strong,nonatomic)NSMutableDictionary *dictCacheContact;

@property (strong, nonatomic) UINavigationController *navCont;


+(AppDelegate*)appDelegate;
-(void)setRootViewController;

@end

