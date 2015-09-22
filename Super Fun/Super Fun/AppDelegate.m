//
//  AppDelegate.m
//  Super Fun
//
//  Created by Ratufa Technologies on 10/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Localization
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
    //Push Notification
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//
    [application registerForRemoteNotifications];
    
    NSDictionary * languageURLPairs = @{
                                        @"en":[[NSBundle mainBundle] URLForResource:@"en.json" withExtension:nil],
                                        @"ar":[[NSBundle mainBundle] URLForResource:@"ar.json" withExtension:nil],
                                        };
    
    [MCLocalization sharedInstance].noKeyPlaceholder = @"[No '{key}' in '{language}']";
    [MCLocalization loadFromLanguageURLPairs:languageURLPairs defaultLanguage:@"ar"];

    
    // Notification for show and hide progress view....
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showProgressBar:) name:ShowMBProgressBar object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideProgressBar:) name:HideMBProgressBar object:nil];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isFirstTime"])
    {
        [MCLocalization sharedInstance].language = @"ar";
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"english"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isFirstTime"];
    }
    _arrCacheGiftList=[[NSMutableArray alloc]init];
    _arrCachePricy=[[NSMutableArray alloc] init];
    _arrCacheHowtoUse=[[NSMutableArray alloc] init];
    _arrCacheTermsCondition=[[NSMutableArray alloc] init];
    _arrCacheFunFairCenter =[[NSMutableArray alloc]init];
    _dictCacheContact = [[NSMutableDictionary alloc]init];
    
    [self setRootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark
#pragma mark -- Set Up Root View Controller
-(void)setRootViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"])
    {
        TabbarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
        self.window.rootViewController = tabBar;
    }
    else
    {
        HomeViewController *loginView = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        _navCont = [[UINavigationController alloc]initWithRootViewController:loginView];
        _navCont.navigationBarHidden = true;
        if ([_navCont respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            _navCont.interactivePopGestureRecognizer.enabled = NO;
        }
        
        self.window.rootViewController=_navCont;
    }

  }

#pragma mark
#pragma mark MBProgressHUD
-(void)showProgressBar:(NSNotification *)notification
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    HUD.labelText = (NSString*)[notification object];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.removeFromSuperViewOnHide = YES;
   // HUD.mode = MBProgressHUDModeCustomView;
    [HUD show:YES];
    [self.window addSubview:HUD];
}
-(void)hideProgressBar:(NSNotification *)notification
{
    [HUD hide:YES];
}
#pragma mark
#pragma mark MBProgressHUD Delegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark
#pragma mark:-Static Delegate Object
+(AppDelegate*)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *deviceTK = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTK = [deviceTK stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSUserDefaults *defaultUser=[NSUserDefaults standardUserDefaults];
    [defaultUser setValue:deviceTK forKey:@"device_token"];
    [defaultUser synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:@"dateValue"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"show_timer_points" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"show_timer_tickets" object:nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
