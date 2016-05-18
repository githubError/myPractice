//
//  CPFLoginViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/17.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFLoginViewController.h"
#import "CPFButton.h"
#import "UIViewExt.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "TKAlertCenter.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface CPFLoginViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *userNameField;
@property (nonatomic,strong) UITextField *passwordField;

@end

@implementation CPFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用户名按钮
    CPFButton *userNameButton = [CPFButton shareButton];
    userNameButton.frame = CGRectMake(40, 160, 60, 30);
    [userNameButton setTitle:@"用户名:" forState:UIControlStateNormal];
    [userNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    userNameButton.titleLabel.font = [UIFont systemFontOfSize:15];
    // 设置按钮文字居中方式
    userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    userNameButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:userNameButton];
    
    // 密码按钮
    CPFButton *passwordButton = [CPFButton shareButton];
    passwordButton.frame = CGRectMake(userNameButton.left, userNameButton.bottom, 60, 30);
    [passwordButton setTitle:@"密    码:" forState:UIControlStateNormal];
    // 设置按钮文字居中方式
    passwordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    passwordButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [passwordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    passwordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:passwordButton];
    
    // 用户名文本框
    UITextField *userNameField = [[UITextField alloc] init];
    userNameField.frame = CGRectMake(userNameButton.right + 10, userNameButton.top, 160, 25);
    userNameField.backgroundColor = [UIColor lightGrayColor];
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    
    _userNameField = userNameField;
    
    [self.view addSubview:_userNameField];
    
    // 密码框
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.frame = CGRectMake(passwordButton.right + 10, passwordButton.top, 160, 25);
    passwordField.backgroundColor = [UIColor lightGrayColor];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.secureTextEntry = YES;
    passwordField.clearsOnBeginEditing = YES;
    
    _passwordField = passwordField;
    [self.view addSubview:_passwordField];
    
    /**
     *  @author 崔鹏飞, 2016-05-17 19:40:09
     *
     *  添加登录按钮响应事件
     */
    CPFButton *loginButton = [CPFButton shareButton];
    loginButton.frame = CGRectMake(passwordButton.right, passwordButton.bottom + 10, 60, 30);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    loginButton.backgroundColor = [UIColor redColor];
    
    //给按钮设置弧度,这里将按钮变成了圆形
    loginButton.layer.cornerRadius = 8.0f;
    loginButton.backgroundColor = [UIColor redColor];
    loginButton.layer.masksToBounds = YES;
    
    loginButton.clickBlock = ^(CPFButton *btn){
        
        if (_userNameField.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入用户名"];
            return ;
        }
        if (_passwordField.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入密码"];
            return ;
        }
        [MBProgressHUD showMessag:@"正在登录..." toView:self.view];
        
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userNameField.text password:self.passwordField.text completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                [appDelegate isLoginSuccess];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                // 允许自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            }
        } onQueue:dispatch_get_main_queue()];
    };
    [self.view addSubview:loginButton];
    
    /**
     *  @author 崔鹏飞, 2016-05-17 19:39:36
     *
     *  添加注册按钮响应事件
     */
    CPFButton *registerButton = [CPFButton shareButton];
    registerButton.frame = CGRectMake(loginButton.right + 20, passwordButton.bottom + 10, 60, 30);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    registerButton.backgroundColor = [UIColor redColor];
    
    //给按钮设置弧度,这里将按钮变成了圆形
    registerButton.layer.cornerRadius = 8.0f;
    registerButton.backgroundColor = [UIColor redColor];
    registerButton.layer.masksToBounds = YES;
    
    registerButton.clickBlock = ^(CPFButton *btn){
        
        if (_userNameField.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入用户名"];
            return ;
        }
        if (_passwordField.text.length == 0) {
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"请输入密码"];
            return ;
        }
        
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:userNameField.text password:passwordField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error) {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"注册成功"];
            } else {
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"注册失败"];
            }
        } onQueue:dispatch_get_main_queue()];
    };
    
    [self.view addSubview:registerButton];
    
}


// 取消UITextField的第一响应者身份
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.passwordField resignFirstResponder];
    [self.userNameField resignFirstResponder];
}

@end
