//
//  ContactUsViewController.h
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactUsViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
}
- (IBAction)actionHotLine:(id)sender;
- (IBAction)actionWebSite:(id)sender;
- (IBAction)actionWhatsApp:(id)sender;
- (IBAction)actionEmail:(id)sender;

@end
