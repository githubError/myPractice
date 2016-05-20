//
//  AppDelegate.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "CPFNavigationController.h"
#import "CPFTabBarController.h"
#import "CPFLoginViewController.h"
#import "MBProgressHUD+Add.h"


@interface AppDelegate ()

@property (nonatomic, strong) CPFTabBarController *tabBarController;

@property (nonatomic, strong) CPFLoginViewController *loginViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _loginViewController = [[CPFLoginViewController alloc] init];
    
    self.window.rootViewController = _loginViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    // 加入环信即时通信SDK，配置AppKey
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"cuipengfei#myim" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger: @0}];
    
    
    // 添加自动登录
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        
        [self isLoginSuccess];
    }
    // 自动获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    return YES;
}

// 登录成功
- (void)isLoginSuccess{
    _tabBarController = [[CPFTabBarController alloc] init];
    self.window.rootViewController = _tabBarController;
}

// 退出登录
- (void)isLogoffSuccess {
    _loginViewController = [[CPFLoginViewController alloc] init];
    self.window.rootViewController = _loginViewController;
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
