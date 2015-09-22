//
//  Header.h
//  Super Fun
//
//  Created by Ratufa Technologies on 11/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#ifndef Super_Fun_Header_h
#define Super_Fun_Header_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "HistoryViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"
#import "BuyTicketsViewController.h"
#import "CollectViewController.h"
#import "TabbarController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "VSPRightPopUpView.h"
#import "SettingsViewController.h"
#import "HowItWorksViewController.h"
#import "ParticipatingCompaniesViewController.h"
#import "GiftListViewController.h"
#import "TermsCoditionsViewController.h"
#import "PrivacyPolicyViewController.h"
#import "ContactUsViewController.h"
#import "TicketsCollectViewController.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "SMSViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworkReachabilityManager.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "Reachability.h"
#import "MCLocalization.h"
#import "MyUtility.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ForgotPassViewController.h"
#import "PointsCollectViewController.h"
#import "VSPDropDownView.h"
#import "KnetViewController.h"

#define RELEASE(a) if (a) {[a release]; a = nil;}
#define ALERT_SHOW(a,b,c) {UIAlertView* alert = [[UIAlertView alloc] initWithTitle: a message: b delegate: nil cancelButtonTitle: c otherButtonTitles: nil]; [alert show];}

/* THIS IS NAVIGATION BAR FRAMEWORK  */
#define NAVIGATION_BAR_RECT   CGRectMake(0.0, 0.0, 320.0, 50.0)


/* COMMON ANIMATION DURATION TIME (IN SECOND)*/
#define  ANIMATION_DURATION 0.3


/* BACKGROUND COLORS STSTIC IN APP */

#define LEFT_MENU_BLACK_COLOR  [UIColor colorWithRed:39.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];

//Indicator
#define ShowMBProgressBar @"showProgress"
#define HideMBProgressBar @"hideProgress"

#define NAVIGATION_BACKGROUND  @"topbg.png"


#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) == 0 )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) == 0 )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) == 0 )
#define IS_IPHONE_6_plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) == 0 )

//#define WebServiceURL @"http://192.168.88.86/t2d/Webservice/"
#define WebServiceURL @"http://q8superfun.com/superfun/"

typedef enum
{
    HowToUse = 1,
    Funfaicenter = 2,
} ViewControler;

#endif
