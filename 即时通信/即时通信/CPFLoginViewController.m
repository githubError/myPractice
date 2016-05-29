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
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.center = self.view.center;
    tipsLabel.frame = CGRectMake(65, 60, 190, 60);
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:20.0f];
    tipsLabel.text = @"请输入用户名和密码直接注册或登录";
    [self.view addSubview:tipsLabel];

    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(40, 160, 25, 25);
    iconView.image = [UIImage imageNamed:@"account"];
    [self.view addSubview:iconView];
    
    UIImageView *pswView = [[UIImageView alloc] init];
    pswView.frame = CGRectMake(iconView.left, iconView.bottom + 10, 25, 25);
    pswView.image = [UIImage imageNamed:@"Card_Lock"];
    [self.view addSubview:pswView];
    
    // 用户名文本框
    UITextField *userNameField = [[UITextField alloc] init];
    userNameField.frame = CGRectMake(iconView.right + 5, iconView.top, 200, 25);
    userNameField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    userNameField.placeholder = @"用户名";
    userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    
    _userNameField = userNameField;
    
    [self.view addSubview:_userNameField];
    
    // 密码框
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.frame = CGRectMake(pswView.right + 5, pswView.top, 200, 25);
    passwordField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.placeholder = @"密码";
    passwordField.secureTextEntry = YES;
    passwordField.clearsOnBeginEditing = YES;
    
    _passwordField = passwordField;
    [self.view addSubview:_passwordField];
    
    /**
     *  @author 崔鹏飞, 2016-05-17 19:40:09
     *
     *  添加登录按钮响应事件
     */
    // 按钮背景图片， 拉伸图片
    UIImage *BtnBkgImg = [UIImage imageNamed:@"fts_green_btn"];
    BtnBkgImg = [BtnBkgImg stretchableImageWithLeftCapWidth:BtnBkgImg.size.width*0.5 topCapHeight:BtnBkgImg.size.height*0.5];
    UIImage *BtnBkgImgHL = [UIImage imageNamed:@"fts_green_btn_HL"];
    BtnBkgImgHL = [BtnBkgImgHL stretchableImageWithLeftCapWidth:BtnBkgImgHL.size.width*0.5 topCapHeight:BtnBkgImgHL.size.height*0.5];
    
    CPFButton *loginButton = [CPFButton shareButton];
    loginButton.frame = CGRectMake(pswView.right + 30, pswView.bottom + 20, 60, 30);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton setBackgroundImage:BtnBkgImg forState:UIControlStateNormal];
    [loginButton setBackgroundImage:BtnBkgImgHL forState:UIControlStateHighlighted];
    
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    loginButton.clickBlock = ^(CPFButton *btn){
        
        // 关闭键盘
        [_userNameField resignFirstResponder];
        [_passwordField resignFirstResponder];
        
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
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                [appDelegate isLoginSuccess];
                // 允许自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                
            }else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[TKAlertCenter defaultCenter] postAlertWithMessage:@"用户名或密码错误"];
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
    registerButton.frame = CGRectMake(loginButton.right + 20, loginButton.top, 60, 30);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [registerButton setBackgroundImage:BtnBkgImg forState:UIControlStateNormal];
    [registerButton setBackgroundImage:BtnBkgImgHL forState:UIControlStateHighlighted];
    
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
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
