//
//  CPFNavigationController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFNavigationController.h"
#import "EaseMob.h"

@interface CPFNavigationController () <EMChatManagerDelegate>

@end

@implementation CPFNavigationController

+ (void)initialize {
    
    // 设置导航栏背景图片
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:[UIColor colorWithRed:55/255 green:50/255 blue:60/255 alpha:1.0]];
    
    // 设置导航栏文字颜色和大小
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]}];
    
    // 设置item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    // UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 即将自动连接
- (void)willAutoReconnect {
    self.title = @"正在连接...";
}

// 自动连接完成
- (void)didAutoReconnectFinishedWithError:(NSError *)error {
    NSLog(@"自动连接完成");
}

//
- (void)didConnectionStateChanged:(EMConnectionState)connectionState {
    self.title = (connectionState == 0)?@"连接成功":@"未连接";
    NSLog(@"网络状态改变");
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    
    NSString *messageString = (message.length == 0)?[NSString stringWithFormat:@"%@：请求添加你为好友",username]:[NSString stringWithFormat:@"%@：请求添加你为好友，附加消息：%@",username,message];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"好友申请" message:messageString preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:@"8001" reason:@"111111" error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送拒绝成功");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:@"8001" error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送同意成功");
        }
    }]];
    
}

@end
