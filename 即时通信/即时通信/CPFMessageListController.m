//
//  CPFMessageListController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMessageListController.h"
#import "DXPopover.h"
#import "UIViewExt.h"
#import "CPFPopoverView.h"

@interface CPFMessageListController ()

@end

@implementation CPFMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"CPFMessageListViewCell" bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"messageCell"];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.bounds = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
}

// addButton响应事件
- (void)addButtonClick:(UIButton *)btn {
    DXPopover *addPopover = [DXPopover popover];
    [addPopover setBackgroundColor:[UIColor clearColor]];
    addPopover.backgroundColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:0.85];

    CPFPopoverView *popover = [[CPFPopoverView alloc] init];
    [addPopover showAtPoint:CGPointMake(btn.left + 20, btn.bottom - 40) popoverPostion:DXPopoverPositionDown withContentView:popover inView:self.view];
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CPFMessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    
    cell.friendLabel.text = @"崔鹏飞";
    cell.messageLabel.text = @"I LOVE YOU";
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"hh:mm"];
    cell.timeLabel.text = [dateFormater stringFromDate:[NSDate date]];
    cell.iconImage.image = [UIImage imageNamed:@"default_header"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
