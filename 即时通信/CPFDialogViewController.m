//
//  CPFDialogViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFDialogViewController.h"
#import "CPFToolView.h"
#import "UIViewExt.h"

@interface CPFDialogViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CPFToolView *toolView;

@end

@implementation CPFDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏标题
    self.title = _buddy.username;
    
    // 初始化添加内容的view
    CPFContentView *contentView = [[CPFContentView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    // 初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.contentView addSubview:_tableView];
    
    // 初始化toolView
    _toolView = [[CPFToolView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, kScreenWidth, 40)];
    [self.contentView addSubview:_toolView];
    
    // 注册键盘弹出是Frame改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// UIKeyboardWillChangeFrameNotification响应方法, 解决弹出键盘遮盖输入框问题
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    CGRect endRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect contentF = self.contentView.frame;
    
    if (kScreenHeight - endRect.origin.y == 0) {
        contentF.origin.y = 0;
    }else{
        contentF.origin.y = -(endRect.size.height);
    }
    self.contentView.frame = contentF;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}


@end
