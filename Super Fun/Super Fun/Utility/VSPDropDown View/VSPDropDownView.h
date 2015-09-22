//
//  VSPDropDownView.h
//  Things2Do
//
//  Created by Vivek on 10/12/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSPDropDownView;
@protocol vSpDropDownDelegate <NSObject>

- (void) vSpDropDownDelegateMethod: (UIButton *) sender;

@end
@interface VSPDropDownView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UIImageView *imgView;
@property (nonatomic, strong) id <vSpDropDownDelegate> delegate;
@property (nonatomic, strong) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)button;

- (id)showDropDownInView:(UIViewController *)viewSuper andWithButton:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSMutableArray *)arr andWithDirection:(NSString *)direction andWithScrollaleValue:(BOOL)isScrollable andWithColor:(UIColor *)color;

@end
