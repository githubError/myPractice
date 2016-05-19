//
//  CPFSearchFriendViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/19.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFSearchFriendViewController.h"
#import "UIViewExt.h"

@interface CPFSearchFriendViewController ()

@end

@implementation CPFSearchFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchInfoField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 240, 30)];
    _searchInfoField.backgroundColor = [UIColor grayColor];
    _searchButton = [CPFButton shareButton];
    _searchButton.frame = CGRectMake(_searchInfoField.right + 10, 80, 30, 30);
    [_searchButton setImage:[UIImage imageNamed:@"add_friend_searchicon"] forState:UIControlStateNormal];
    _searchButton.clickBlock = ^(CPFButton *btn){
        NSLog(@"_searchButtonClicked");
    };
    [self.view addSubview:_searchButton];
    [self.view addSubview:_searchInfoField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
