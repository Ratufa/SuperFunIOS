//
//  VSPRightPopUpView.h
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSPRightPopUpDelegate <NSObject>

- (void) vSpRightPopUpDelegateMethod: (NSInteger) selectedIndex;

@end

@interface VSPRightPopUpView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UIImageView *imgView;
@property (nonatomic, strong) id <VSPRightPopUpDelegate> delegate;
@property (nonatomic, strong) NSString *animationDirection;

-(void)hideRightPopUpView;

- (id)showRightPopUpInView:(UIViewController *)viewSuper andWithButton:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSArray *)array andWithScrollaleValue:(BOOL)isScrollable andWithColor:(UIColor *)color;

@end
