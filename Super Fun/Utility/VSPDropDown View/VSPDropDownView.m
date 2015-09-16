//
//  VSPDropDownView.m
//  Things2Do
//
//  Created by Vivek on 10/12/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "VSPDropDownView.h"
#import "QuartzCore/QuartzCore.h"

@interface VSPDropDownView ()
{
    UIColor *colorValue;
    UIFont *font;
    CGRect btnSuperViewFrame;
}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSMutableArray *arraylist;
@end

@implementation VSPDropDownView

- (id)showDropDownInView:(UIViewController *)viewSuper andWithButton:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSMutableArray *)arr andWithDirection:(NSString *)direction andWithScrollaleValue:(BOOL)isScrollable andWithColor:(UIColor *)color
{
     colorValue = color;
    _btnSender = button;
    _animationDirection = direction;
    
    font = button.titleLabel.font;
    
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = button.frame;
        
        _arraylist = [NSMutableArray arrayWithArray:arr];
        
        btnSuperViewFrame = [button convertRect:button.bounds toView:viewSuper.view];
        
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y+btn.size.height, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.layer.cornerRadius = 5;
        [_table setScrollEnabled:isScrollable];
        _table.backgroundColor = [UIColor clearColor];
        [_table setShowsHorizontalScrollIndicator:NO];
        [_table setShowsVerticalScrollIndicator:NO];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        if ([direction isEqualToString:@"up"])
        {
            self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y-height, btn.size.width,height);
        }
        else if([direction isEqualToString:@"down"])
        {
            self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y+btn.size.height, btn.size.width, height);
        }
        _table.frame = CGRectMake(0, 0, btn.size.width, height);
        [UIView commitAnimations];
        [self addSubview:_table];
        
        [viewSuper.view addSubview:self];

    }
    return self;

}
-(void)hideDropDown:(UIButton *)button
{
    CGRect btn = button.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    if ([_animationDirection isEqualToString:@"up"])
    {
        self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y, btn.size.width, 0);
    }
    else if ([_animationDirection isEqualToString:@"down"])
    {
        self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y+btn.size.height, btn.size.width, 0);
    }
    _table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arraylist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UILabel *label;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        [tableView setLayoutMargins:UIEdgeInsetsZero];
       
        label = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, tableView.frame.size.width-5, 21)];
        label.textColor = colorValue;
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        /*
        cell.textLabel.font = font;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.frame = CGRectMake(-20, cell.textLabel.frame.origin.y, cell.textLabel.frame.size.width, cell.textLabel.frame.size.height);
        */
        

//       cell.backgroundColor = [UIColor grayColor];
        
    }

    label.text = [_arraylist objectAtIndex:indexPath.row];
    
    [cell addSubview:label];
   /*
    cell.textLabel.textColor = colorValue;
    cell.textLabel.text = [_arraylist objectAtIndex:indexPath.row];
    */
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideDropDown:_btnSender];
    
    [_btnSender setTitle:[[_arraylist objectAtIndex:indexPath.row] capitalizedString] forState:UIControlStateNormal];
    [_btnSender setTag:indexPath.row];
    [_btnSender setTintColor:[UIColor blackColor]];
//    for (UIView *subview in _btnSender.subviews) {
//        
//        if ([subview isKindOfClass:[UIImageView class]]) {
//            [subview removeFromSuperview];
//        }
//    }
//    _imgView.image = c.imageView.image;
//    _imgView = [[UIImageView alloc] initWithImage:c.imageView.image];
//    _imgView.frame = CGRectMake(5, 5, 25, 25);
//    [_btnSender addSubview:_imgView];
    [self myDelegate:_btnSender];
}

- (void) myDelegate:(UIButton *)sender
{
    [self.delegate vSpDropDownDelegateMethod:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
