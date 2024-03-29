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

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 70, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        // 修改导航栏左边的item
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (void)back {
    [self popToRootViewControllerAnimated:YES];
}

@end
