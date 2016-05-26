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
#import "CPFButton.h"

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

@interface CPFMeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    CPFButton *_logoutBtn;
}


@end

@implementation CPFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 200) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
    _logoutBtn = [CPFButton shareButton];
    _logoutBtn.frame = CGRectMake(self.view.center.x - 50, kScreenHeight - 180, 100, 30);
    
    UIImage *BtnBkgImg = [UIImage imageNamed:@"logout_click"];
    BtnBkgImg = [BtnBkgImg stretchableImageWithLeftCapWidth:BtnBkgImg.size.width*0.5 topCapHeight:BtnBkgImg.size.height*0.5];
    UIImage *BtnBkgImgHL = [UIImage imageNamed:@"logout"];
    BtnBkgImgHL = [BtnBkgImgHL stretchableImageWithLeftCapWidth:BtnBkgImgHL.size.width*0.5 topCapHeight:BtnBkgImgHL.size.height*0.5];
    
    [_logoutBtn setBackgroundImage:BtnBkgImg forState:UIControlStateNormal];
    [_logoutBtn setBackgroundImage:BtnBkgImgHL forState:UIControlStateHighlighted];
    [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_logoutBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    __block CPFMeViewController *meViewCtr = self;
    _logoutBtn.clickBlock = ^(CPFButton *btn){
        [MBProgressHUD showMessag:@"正在退出" toView:meViewCtr.view];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                NSLog(@"======%@",info);
                AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
                [myDelegate isLogoffSuccess];
                [MBProgressHUD hideAllHUDsForView:meViewCtr.view animated:YES];
            } else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"退出失败"];
                [MBProgressHUD hideAllHUDsForView:meViewCtr.view animated:YES];
            }
        } onQueue:nil];
    };
    
    [self.view addSubview:_logoutBtn];
    
    [self.view addSubview:_tableView];
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
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
        cell.imageView.image = [UIImage imageNamed:@"default_header"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 30;
}

@end
