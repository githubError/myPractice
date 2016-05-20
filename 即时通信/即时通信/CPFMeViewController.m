//
//  CPFMeViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "EaseMob.h"
#import "TKAlertCenter.h"

@interface CPFMeViewController ()

@end

@implementation CPFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"退出登录";
        [cell.textLabel setTextColor:[UIColor redColor]];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [MBProgressHUD showMessag:@"正在退出" toView:self.view];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                NSLog(@"======%@",info);
                AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
                [myDelegate isLogoffSuccess];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            } else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"退出失败"];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        } onQueue:nil];
    }
}

@end
