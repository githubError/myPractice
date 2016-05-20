//
//  CPFSearchFriendViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/19.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFSearchFriendViewController.h"
#import "UIViewExt.h"

@interface CPFSearchFriendViewController () <UITextFieldDelegate>

@end

@implementation CPFSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchInfoField = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 240, 30)];
    _searchInfoField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    _searchButton = [CPFButton shareButton];
    _searchInfoField.borderStyle = UITextBorderStyleRoundedRect;
    _searchInfoField.delegate = self;
    _searchInfoField.placeholder = @"用户名/群组";
    _searchButton.frame = CGRectMake(_searchInfoField.right, 40, 30, 30);
    [_searchButton setImage:[UIImage imageNamed:@"add_friend_searchicon"] forState:UIControlStateNormal];
    _searchButton.clickBlock = ^(CPFButton *btn){
        NSLog(@"_searchButtonClicked");
    };
    [self.view addSubview:_searchInfoField];
    [self.view addSubview:_searchButton];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchInfoField resignFirstResponder];
    
    
    return YES;
}

@end
