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
    
}

//
- (void)didConnectionStateChanged:(EMConnectionState)connectionState {
    self.title = (connectionState == 0)?@"连接成功":@"未连接";
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
