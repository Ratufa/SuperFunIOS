//
//  VSPRightPopUpView.m
//  Super Fun
//
//  Created by Ratufa Technologies on 12/06/15.
//  Copyright (c) 2015 Ratufa Technologies. All rights reserved.
//

#import "VSPRightPopUpView.h"
#import "MCLocalization.h"
#define IS_IPHONE4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) == 0 )

@interface VSPRightPopUpView ()
{
    UIColor *colorValue;
    CGRect btnSuperViewFrame;

}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, retain) NSArray *arraylist;

@end

@implementation VSPRightPopUpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)showRightPopUpInView:(UIViewController *)viewSuper andWithButton:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSArray *)array andWithScrollaleValue:(BOOL)isScrollable andWithColor:(UIColor *)color
{
    colorValue = color;
    self.hidden = NO;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = button.frame;
        
        _arraylist = [NSArray arrayWithArray:array];
        
        btnSuperViewFrame = [button convertRect:button.bounds toView:viewSuper.view];
        
        
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
        _table.backgroundColor =[UIColor colorWithRed:235.0/255.0 green:225.0/255.0 blue:156.0/255.0 alpha:1.0];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//    
        self.frame = CGRectMake(viewSuper.view.frame.size.width-222,  btnSuperViewFrame.origin.y+btnSuperViewFrame.size.height+15, 207,height);
        self.layer.shadowOffset = CGSizeMake(-5, -5);

        _table.frame = CGRectMake(0, 0, 207, height);
    //    [UIView commitAnimations];
        [self addSubview:_table];
        self.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:240.0/255. blue:216.0/255.0 alpha:1.0];
        [viewSuper.view addSubview:self];
        
    }
    return self;
}
-(void)hideRightPopUpView
{
    
  //  [UIView beginAnimations:nil context:nil];
  //  [UIView setAnimationDuration:0.5];
   
    self.frame = CGRectMake(btnSuperViewFrame.origin.x, btnSuperViewFrame.origin.y+btnSuperViewFrame.size.height, 207, 0);
    _table.frame = CGRectMake(0, 0, 207,0);
  //  [UIView commitAnimations];
}
#pragma mark
#pragma mark -- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE4) {
        
        return 40;
    }
    return 48;
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
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        if (IS_IPHONE4) {
            
        label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-18, 40)];
        }
        else
        {
            label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, tableView.frame.size.width-18, 48)];
        }
        label.textColor = colorValue;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"english"])
        {
            label.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
            label.textAlignment = NSTextAlignmentRight;

        }
        else
        {
            label.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
            label.textAlignment = NSTextAlignmentRight;
 
        }
            }
    
    label.text = [_arraylist objectAtIndex:indexPath.row];
   
    [cell addSubview:label];
  
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate vSpRightPopUpDelegateMethod:indexPath.row];
}


@end
