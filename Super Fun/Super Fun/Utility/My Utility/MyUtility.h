//
//  MyUtility.h
//  Room_Matcher
//
//  Created by Dev Thakur on 17/09/14.
//  Copyright (c) 2014 Avnish Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Header.h"

@interface MyUtility : NSObject <NSURLSessionDelegate>


//Hide Status Bar
+(void)hideStatusBar:(BOOL)hide;


//+(BOOL)setUp_VSP_Left_Right_Menu;

//Extra Method
+(BOOL)isSetcornorRadius:(UIView *)view withRadius:(CGFloat)radius;
+(BOOL)isSetplashHGolderWithColor:(UITextField *)textfeld AndplashHolder:(NSString *)plashholder;

//String Method
+(BOOL) isValidPhone:(NSString*) phoneString;
+(BOOL)isValideMobileNo:(NSString *)mobileNo;
+(BOOL)isValidateEmail:(NSString*)email;
+(BOOL)isBlankTextField:(NSString*)string;
+(BOOL)isCheckWhiteSpace:(NSString *)text;
+(BOOL)isCheckNumberOfCharOfPass:(NSString *)password;
+(NSString *)getFormattedString:(NSString *)strTitle;
+(NSString *)removeWhiteSpace:(NSString *)text;


//ColorString
+(NSMutableAttributedString *)setTitleWithstring:(NSAttributedString *)string withStartingRange:(NSInteger)startRange andUptoRange:(NSInteger)uptoRange andWithColor:(UIColor*)color;
+(NSMutableAttributedString *)setFontAndColorOfTextWithstring:(NSString *)string withStartingRange:(NSInteger)startRange andUptoRange:(NSInteger)uptoRange andWithColor:(UIColor*)color andWithFont:(UIFont *)font;
+ (NSMutableAttributedString*) setColor:(UIColor*)color word:(NSString*)word inText:(NSMutableAttributedString*)mutableAttributedString;
//Calender

+(NSPredicate *)getPredicateForToday;
+(NSPredicate *)getPredicateForTommorow;
+(NSPredicate *)getPredicateForWeek;

+(NSPredicate *)getPredicateForWeekend;
//ConvertImage Into Base64
+(NSString*)base64forData:(NSData*)theData;
//Shared Instance
+(MyUtility *)utilitySharedInstance;

//IP Address
+ (NSString *)getIPAddress;
//UDID
+(NSString *)getUUIdofDevice;

+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;

+(void)postMethodWithApiMethod:(NSString *)strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(void)getMethodWithApiMethod:(NSString *)strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
+(BOOL)isInterNetConnection;

+(void)pushToViewController:(UIViewController *)toViewController FromController:(UIViewController *)fromViewController WithIdentifier:(NSString *)identifier;
+(void)pushSelectedIndexOfRightPopUp:(NSInteger)indexNo andWithAlreadyOnViewIndex:(NSInteger)alreadyOnViewIndex andFromController:(UIViewController *)fromController;
+(void)printFontNames;
+(BOOL)isOnlyNumeric:(NSString *)string;

@end
