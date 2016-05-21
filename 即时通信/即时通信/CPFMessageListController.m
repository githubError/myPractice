//
//  CPFMessageListController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMessageListController.h"
#import "UIViewExt.h"
#import "CPFPopoverView.h"
#import "CPFSearchFriendViewController.h"
#import "EaseMob.h"
#import "TKAlertCenter.h"

@interface CPFMessageListController () <CPFCustomMenuDelegate,EMChatManagerDelegate>

@property (nonatomic, strong) CPFPopoverView *menu;

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
    
    // 设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}

// addButton响应事件
- (void)addButtonClick:(UIButton *)btn {
    __weak __typeof(self) weakSelf = self;
    if (!self.menu) {
        self.menu = [[CPFPopoverView alloc] initWithDataArr:@[@"添加好友", @"加入群聊"] origin:CGPointMake(160, 0) width:140 rowHeight:44];
        _menu.delegate = self;
        _menu.dismiss = ^() {
            weakSelf.menu = nil;
        };
        _menu.arrImgName = @[@"contacts_add_friend", @"contacts_add_newmessage"];
        [self.view addSubview:_menu];
    } else {
        [_menu dismissWithCompletion:^(CPFPopoverView *object) {
            weakSelf.menu = nil;
        }];
    }
}

- (void)CPFCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select: %d", indexPath.row);
    if (indexPath.row == 0) {
        CPFSearchFriendViewController *searchViewController = [[CPFSearchFriendViewController alloc] init];
        
        [searchViewController setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
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


#pragma mark - EMCallManagerDelegate

/**
 *  @author 崔鹏飞, 2016-05-20 19:32:53
 *
 *  接受到好友申请时调用
 *
 *  @param username 申请人用户名
 *  @param message  附加信息
 */
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    
    NSString *messageString = (message.length == 0)?[NSString stringWithFormat:@"%@：请求添加你为好友",username]:[NSString stringWithFormat:@"%@：请求添加你为好友，附加消息：%@",username,message];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友申请" message:messageString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"对方拒绝添加你为好友" error:&error];
        if (isSuccess && !error) {
            EMError *error = nil;
            BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"对方拒绝添加你为好友" error:&error];
            if (isSuccess && !error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"已拒绝"];
            } else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"拒绝时出现错误"];
            }
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (isSuccess && !error) {
            EMError *error = nil;
            BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
            if (isSuccess && !error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"添加成功"];
            }else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"添加失败"];
            }
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
