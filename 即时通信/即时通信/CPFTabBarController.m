//
//  CPFTabBarController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFTabBarController.h"
#import "CPFNavigationController.h"
#import "CPFMessageListController.h"
#import "CPFFriendListController.h"
#import "CPFMeViewController.h"
#import "EaseMob.h"
@interface CPFTabBarController ()

@end

@implementation CPFTabBarController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置并拉伸tabBar背景图片
    UIImage *tabbarBkgImage = [UIImage imageNamed:@"tabbarBkg"];
    tabbarBkgImage = [tabbarBkgImage stretchableImageWithLeftCapWidth:tabbarBkgImage.size.width * 0.5 topCapHeight:tabbarBkgImage.size.height * 0.5];
    self.tabBar.backgroundImage = tabbarBkgImage;
    
    [self setupChildVc:[[CPFMessageListController alloc] init] navigationTitle:@"即时通信" tabBarTitle:@"消息" image:@"tabbar_mainframe" selectedImage:@"tabbar_mainframeHL"];
    
    [self setupChildVc:[[CPFFriendListController alloc] init] navigationTitle:@"联系人" tabBarTitle:@"联系人" image:@"tabbar_contacts" selectedImage:@"tabbar_contactsHL"];
    
    [self setupChildVc:[[CPFMeViewController alloc] init] navigationTitle:@"我" tabBarTitle:@"我" image:@"tabbar_me" selectedImage:@"tabbar_meHL"];
    
}

- (void)setupChildVc:(UIViewController *)vc navigationTitle:(NSString *)navTitle tabBarTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = navTitle;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    CPFNavigationController *nav = [[CPFNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
