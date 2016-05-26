//
//  CPFFriendListController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFFriendListController.h"
#import "EaseMob.h"
#import "TKAlertCenter.h"
#import "CPFDialogViewController.h"
#import "CPFFriendList.h"

@interface CPFFriendListController () <EMChatManagerDelegate, EMChatManagerBuddyDelegate>



@end

@implementation CPFFriendListController

- (void)viewWillAppear:(BOOL)animated{
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            _friendList = [NSMutableArray array];
            _friendList = buddyList;
        }else {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"获取好友列表失败"];
        }
    } onQueue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _friendList = [NSArray array];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _friendList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    EMBuddy *buddy = _friendList[indexPath.row];
    cell.textLabel.text = buddy.username;
    return cell;
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CPFDialogViewController *dialogViewController = [[CPFDialogViewController alloc] init];
    [dialogViewController setHidesBottomBarWhenPushed:YES];
    dialogViewController.buddy = _friendList[indexPath.row];
    [self.navigationController pushViewController:dialogViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

#pragma mark - EMChatManagerBuddyDelegate

- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd {
    _friendList = buddyList;
    [self.tableView reloadData];
}

- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error {
    if (!error) {
        _friendList = buddyList;
        NSLog(@"didFetchedBuddyList成功 ----%@",_friendList);
        [self.tableView reloadData];
    }else{
        NSLog(@"didFetchedBuddyList失败 ----%@",_friendList);
    }
}

@end
