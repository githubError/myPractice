//
//  CPFSearchFriendViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/19.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFSearchFriendViewController.h"
#import "UIViewExt.h"
#import "EaseMob.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "TKAlertCenter.h"


@interface CPFSearchFriendViewController () <UITextFieldDelegate>

@property (nonatomic, assign) NSArray *userList;

@end

@implementation CPFSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userList = [NSArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _userInfoField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 30)];
    _userInfoField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    _userInfoField.borderStyle = UITextBorderStyleRoundedRect;
    _userInfoField.keyboardType = UIKeyboardTypeEmailAddress;
    _userInfoField.delegate = self;
    _userInfoField.placeholder = @"用户名/群组";
    
    _messageField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 280, 60)];
    _messageField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    _messageField.borderStyle = UITextBorderStyleRoundedRect;
    _messageField.keyboardType = UIKeyboardTypeASCIICapable;
    _messageField.placeholder = @"附加信息";
    _messageField.delegate = self;
    
    _commitButton = [CPFButton shareButton];
    
    _commitButton.frame = CGRectMake(_userInfoField.center.x - 40, 150, 80, 30);
    _commitButton.backgroundColor = [UIColor redColor];
    _commitButton.layer.cornerRadius = 8.0f;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commitButton setTitle:@"添加好友" forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userInfoField];
    [self.view addSubview:_messageField];
    [self.view addSubview:_commitButton];
    
}


- (void)addFriend{
    [MBProgressHUD showMessag:@"正在发送请求..." toView:self.view];
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_userInfoField.text message:_messageField.text error:nil];
    if (isSuccess) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送成功"];
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送失败失败"];
        
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_userInfoField resignFirstResponder];
    [_messageField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_userInfoField resignFirstResponder];
    [_messageField resignFirstResponder];
    return YES;
}

@end
