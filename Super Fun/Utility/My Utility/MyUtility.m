//
//  MyUtility.m
//  Things2Do
//
//  Created by Dev Thakur on 17/09/14.
//  Copyright (c) 2014 Sycraft. All rights reserved.
//

#import "MyUtility.h"
#import "Header.h"

@interface MyUtility  ()

@end

static MyUtility *objUtility;

@implementation MyUtility

/* This is a common method for add navigation bar */

//this method will return formatted String
+(NSString *)getFormattedString:(NSString *)strTitle
{
    NSString *encodedString = strTitle;
    NSString *decodedString = [NSString stringWithUTF8String:[encodedString cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    return decodedString;
}
+ (NSString *)formattedDateStringFromString:(NSString *)strdate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"EEE, dd MMM yyyy hh:mm:ss zzzz"];
    NSDate *date= [formatter dateFromString:strdate];
    [formatter setDateFormat: @"EEE, dd MMM YYYY"];
    NSString *strFormetedDate= [formatter stringFromDate:date];
    return strFormetedDate;
}
/*****-------VALIDATION FOR ALPHANUMERIC PASSWORD PHONE NUMBER------*****/
-(BOOL)isAlphaNumericOnly:(NSString *)input
{
    NSString *alphaNum = @"[a-zA-Z0-9]+";
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNum];
    
    return [regexTest evaluateWithObject:input];
}
/*****--------------VALIDATION FOR PHONE NUMBER--------------------******/
+ (BOOL) isValidPhone:(NSString*) phoneString {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneString length]);
    NSArray *matches = [detector matchesInString:phoneString options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0)
    {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}
/******---------VALIDATION FOR PHONE NUMBER UPTO 14 DIGIT----------*******/
+(BOOL)isValideMobileNo:(NSString *)mobileNo
{
    /*
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL phoneValidates = [phoneTest evaluateWithObject:mobileNo];
    return phoneValidates;
    */
    NSString *mobileNumberPattern = @"[965][0-9]{7}";
     NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
     
     BOOL matched = [mobileNumberPred evaluateWithObject:mobileNo];
     return matched;
 
}
/*******------------------VALIDATION FOR EMAIL--------------------*******/
+(BOOL)isValidateEmail:(NSString*)email
{
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1)
        {	NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray2)
        {	NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }else
        return NO;
}

/*******------------------VALIDATION FOR BLANK TEXTFEILD--------------------*******/
+(BOOL)isBlankTextField:(NSString*)string
{
    if ([string isEqualToString:@""]) {
        
        return YES;
        
    }
    else{
        
        return NO;
        
    }
}
/*******-------------VALIDATION FOR CHECK NUMBER OF CHARACTER-----------------*******/
+(BOOL)isCheckNumberOfCharOfPass:(NSString *)password
{
    if ([password length]>5)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark-- Utility Shared Instance
+(MyUtility *)utilitySharedInstance
{
    if (objUtility == nil)
    {
        objUtility = [[MyUtility alloc]init];
    }
    return objUtility;
}
#pragma mark Hide Status Bar
+(void)hideStatusBar:(BOOL)hide{
    
    if (hide) {
        
        [UIApplication sharedApplication].statusBarHidden=YES;
        
    }else{
        
        [UIApplication sharedApplication].statusBarHidden=NO;
    }
    
}

/* This is a common method for set cornors with radius*/
+(BOOL)isSetcornorRadius:(UIView *)view withRadius:(CGFloat)radius
{
    view.layer.cornerRadius=radius;
    view.layer.borderWidth=1.0;
    view.layer.borderColor=[UIColor whiteColor].CGColor;
    view.layer.masksToBounds=YES;
    return YES;
}
#pragma mark -- Check White Spaces
/* This is a commoon method for check if textfield contain space like user name*/
+(BOOL)isCheckWhiteSpace:(NSString *)text
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range = [text rangeOfCharacterFromSet:whitespace];
    if (range.location != NSNotFound)
    {
        return NO;
        // There is whitespace.
    }
    return YES;
}
#pragma mark -- Remove White Spaces
+(NSString *)removeWhiteSpace:(NSString *)text
{
    NSString *trimmedString = [text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}
/* This is method for set header of table view */
+(BOOL)isSetHederStart:(UITableView *)tableview
{
    tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -20.0f, tableview.bounds.size.width, 0.01f)];
    return YES;
}
/* This is a method for set plash holder and color*/
+(BOOL)isSetplashHGolderWithColor:(UITextField *)textfeld AndplashHolder:(NSString *)plashholder
{
    if ([textfeld respondsToSelector:@selector(setAttributedPlaceholder:)])
    {
        UIColor *color = [UIColor whiteColor];
        
        textfeld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:plashholder attributes:@{NSForegroundColorAttributeName: color}];
    } else
    {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        
    }
    return YES;
}
/* THIS IS SETUP FOR LEFT MENU VIEW */

/*
 +(BOOL)setUp_VSP_Left_Right_Menu
 {
 
 VSPNavController *container = [[VSPNavController alloc]initWithRootViewController:[self demoController]];
 
 AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
 app.window.rootViewController=container;
 
 return YES;
 
 }
 
 +(BOOL)SetUp_Left_Right_Menu
 {
 NSString *strStoaryBoard = IS_IPHONE_4 ? @"Storyboard":@"Main";
 
 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strStoaryBoard bundle:nil];
 //
 //        LeftMenuViewController *leftMenuView = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
 //
 //        RightMenuViewController *rightView = [storyboard instantiateViewControllerWithIdentifier:@"RightMenuViewController"];
 
 MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
 containerWithCenterViewController:[self navigationController]
 leftMenuViewController:nil
 rightMenuViewController:nil];
 
 AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
 app.window.rootViewController=container;
 
 [self.menuContainerViewController toggleRightSideMenuCompletion:^{
 
 }];
 return YES;
 }
 
 + (HomeViewController *)demoController
 
 {
 NSString *strStoaryBoard = IS_IPHONE_4 ? @"Storyboard":@"Main";
 
 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:strStoaryBoard bundle:nil];
 
 HomeViewController *demo = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
 return demo;
 }
 
 + (UINavigationController *)navigationController{
 
 UINavigationController *navigation=[[UINavigationController alloc]
 initWithRootViewController:[self demoController]];
 
 return navigation;
 }
 */
#pragma mark -- Set color string
+(NSMutableAttributedString *)setTitleWithstring:(NSAttributedString *)string withStartingRange:(NSInteger)startRange andUptoRange:(NSInteger)uptoRange andWithColor:(UIColor*)color
{
    NSMutableAttributedString *text =[[NSMutableAttributedString alloc]initWithAttributedString: string];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:NSMakeRange(startRange ,uptoRange)];
    return text;
}
+(NSMutableAttributedString *)setFontAndColorOfTextWithstring:(NSString *)string withStartingRange:(NSInteger)startRange andUptoRange:(NSInteger)uptoRange andWithColor:(UIColor*)color andWithFont:(UIFont *)font
{
    
    NSRange range = NSMakeRange(startRange,uptoRange);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attrString beginEditing];
    [attrString addAttribute:NSFontAttributeName
                       value:font
                       range:range];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:range];
    
    [attrString endEditing];
    return attrString;
}
+ (NSMutableAttributedString*) setColor:(UIColor*)color word:(NSString*)word inText:(NSMutableAttributedString*)mutableAttributedString {
    
    NSUInteger count = 0, length = [mutableAttributedString length];
    NSRange range = NSMakeRange(0, length);
    
    while(range.location != NSNotFound)
    {
        range = [[mutableAttributedString string] rangeOfString:word options: NSCaseInsensitiveSearch range:range];
        if(range.location != NSNotFound) {
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                            value:[UIColor redColor]
                                            range:NSMakeRange(range.location ,[word length])];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    return mutableAttributedString ;
}

#pragma mark -- Filteration Through Dates
/******------------------------For Today-----------------------******/
+(NSPredicate *)getPredicateForToday
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dealDate = [NSDate date];
    
    NSString *dateStr = [dateFormatter stringFromDate:dealDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sdate = %@",dateStr];
    return predicate;
}
/******------------------------For Tommorow-----------------------******/
+(NSPredicate *)getPredicateForTommorow
{
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init] ;
    [deltaComps setDay:1];
    
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [dateFormatter stringFromDate:tomorrow];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sdate = %@",date];
    return predicate;
}
/******------------------------For Week-----------------------******/
+(NSPredicate *)getPredicateForWeek
{
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init] ;
    [deltaComps setDay:6];
    
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateOfAfter7Days = [dateFormatter stringFromDate:tomorrow];
    
    NSDate *dealDate = [NSDate date];
    
    NSString *today = [dateFormatter stringFromDate:dealDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sdate >= %@) AND (sdate =< %@)", today,dateOfAfter7Days];
    
    return predicate;
}
/******------------------------For Calender-----------------------******/

/******------------------------For Weekend-----------------------******/
+(NSPredicate *)getPredicateForWeekend
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];// you can use your format.
    //Week End Date
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *componentsEnd = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth)  fromDate:today];
    NSInteger Enddayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:today] weekday];// this will give you current day of week
    
    [componentsEnd setDay:([componentsEnd day]+(7-Enddayofweek)+1)];// for end day of the week
    
    NSDate *EndOfWeek = [gregorian dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    
    NSDate *weekEndPrev = [dateFormat_End dateFromString:dateEndPrev] ;
    
    NSDateComponents* deltaComps = [[NSDateComponents alloc] init] ;
    [deltaComps setDay:-1];
    
    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:weekEndPrev options:0];
    
    NSString *sundayDay = nil;
    
    NSString *saturdayDay = nil;
    if (Enddayofweek == 1)
    {
        sundayDay = [dateFormat stringFromDate:today];
        NSLog(@"SunDay--%@",sundayDay);
        saturdayDay = sundayDay;
        
    }
    else
    {
        sundayDay = [dateFormat stringFromDate:weekEndPrev];
        NSLog(@"SunDay--%@",sundayDay);
        
        saturdayDay = [dateFormat stringFromDate:tomorrow];
        NSLog(@"SatDay--%@",saturdayDay);
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sdate >= %@) AND (sdate =< %@)", saturdayDay,sundayDay];
    
    return predicate;
}

#pragma mark -- Convert Into Base64
+(NSString*)base64forData:(NSData*)theData{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

#pragma mark -- Releated of App
+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}
#pragma mark
#pragma mark -- Date Difference
+(NSInteger)dateDiff:(NSString *)origDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    // [df release];
    NSDate *todayDate = [NSDate date];
    
    NSString *currentTime = [df stringFromDate:todayDate];
    
    NSDate *newDate = [df dateFromString:currentTime];
    double ti = [convertedDate timeIntervalSinceDate:newDate];
    ti = ti * -1;
    if(ti < 1) {
        return 0;
    } else if (ti < 60) {
        return 0.5;
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return diff;
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return diff;
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return diff;
    } else if (ti < 31536000)
    {
        int diff = round(ti / 60 / 60 / 24 / 30);
        return diff;
    }
    else{
        int diff = round(ti / 60 / 60 / 24 / 365);
        return diff;
    }
    return 0;
    
}
+(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
+ (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
+(NSString *)getUUIdofDevice
{
    // This is will run if it is iOS6
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark
#pragma mark -- AFNetworking Utility Methods
+(void)postMethodWithApiMethod:(NSString *)strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",WebServiceURL,strurl]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         success (responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         failure(error);
     }];
    
}
+(void)getMethodWithApiMethod:(NSString *)strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@",WebServiceURL,strurl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success (responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
+(BOOL)isInterNetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        return NO;
    }
    else
    {
        return YES;
    }
}
+(void)pushToViewController:(UIViewController *)toViewController FromController:(UIViewController *)fromViewController WithIdentifier:(NSString *)identifier
{
    toViewController = [fromViewController.storyboard instantiateViewControllerWithIdentifier:identifier];
    [fromViewController.navigationController pushViewController:toViewController animated:YES];
}
#pragma mark -- Push Method For LeftDrawer
+(void)pushSelectedIndexOfRightPopUp:(NSInteger)indexNo andWithAlreadyOnViewIndex:(NSInteger)alreadyOnViewIndex andFromController:(UIViewController *)fromController
{
    
    TabbarController *objTabbarController = (TabbarController *)fromController.tabBarController;
    objTabbarController.viewForTabs.hidden = YES;
    if (indexNo == 0 && indexNo != alreadyOnViewIndex)
    {
     [self pushToViewController:(SettingsViewController.self) FromController:fromController WithIdentifier:@"SettingsViewController"];
    }
    else if (indexNo == 1 && indexNo != alreadyOnViewIndex)
    {
      [self pushToViewController:(HowItWorksViewController.self) FromController:fromController WithIdentifier:@"HowItWorksViewController"];
    }
    else if (indexNo == 2 && indexNo != alreadyOnViewIndex)
    {
          [self pushToViewController:(ParticipatingCompaniesViewController.self) FromController:fromController WithIdentifier:@"ParticipatingCompaniesViewController"];
    }
    else if (indexNo == 3 && indexNo != alreadyOnViewIndex)
    {
        [self pushToViewController:(GiftListViewController.self) FromController:fromController WithIdentifier:@"GiftListViewController"];
    }
    else if (indexNo == 4 && indexNo != alreadyOnViewIndex)
    {
        [self pushToViewController:(TermsCoditionsViewController.self) FromController:fromController WithIdentifier:@"TermsCoditionsViewController"];
    }
    else if (indexNo == 5 && indexNo != alreadyOnViewIndex)
    {
         [self pushToViewController:(PrivacyPolicyViewController.self) FromController:fromController WithIdentifier:@"PrivacyPolicyViewController"];
    }
    else if (indexNo == 6 && indexNo != alreadyOnViewIndex)
    {
       [self pushToViewController:(ContactUsViewController.self) FromController:fromController WithIdentifier:@"ContactUsViewController"];
    }
}
+(void)printFontNames
{
    NSArray *fontFamilies = [UIFont familyNames];
    for (int i = 0; i < [fontFamilies count]; i++)
    {
        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}
+(BOOL)isOnlyNumeric:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    return isNumeric;
}
@end
