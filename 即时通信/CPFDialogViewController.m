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
#import "CPFMoreSelectView.h"


#define KMoreSelectViewHeight 100

@interface CPFDialogViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    UITableView *_tableView;
    CPFToolView *_toolView;
}

@property (nonatomic, weak) CPFMoreSelectView *moreSelectView;
@property (nonatomic,weak) UITextView *textView;

@end

@implementation CPFDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏标题
    self.title = _buddy.username;
    __block CPFDialogViewController *dialogViewCtr = self;
    
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
    _toolView.beginEditBlock = ^(UITextView *textView) {
        [dialogViewCtr hideMoreSelectView];
        dialogViewCtr.textView = textView;
    };
    
    // 初始化moreSelectView
    CPFMoreSelectView *moreSelectView = [[CPFMoreSelectView alloc] initWithImageBtnBlock:^{
        NSLog(@"---点击了图片按钮");
    } CallBtnBlock:^{
        NSLog(@"---点击了语音按钮");
    } VideoBtnBlock:^{
        NSLog(@"---点击了视频按钮");
    }];
    moreSelectView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, KMoreSelectViewHeight);
    self.moreSelectView = moreSelectView;
    [[UIApplication sharedApplication].keyWindow addSubview:moreSelectView];
    
    
    // 注册键盘弹出是Frame改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // inputView的moreSelectBtn点击事件
    _toolView.moreBtnBlock = ^(){
        if (dialogViewCtr.textView.isFirstResponder) {
            [dialogViewCtr.textView resignFirstResponder];
            moreSelectView.top = kScreenHeight - KMoreSelectViewHeight;
            dialogViewCtr.contentView.top = - KMoreSelectViewHeight;
        }else{
            dialogViewCtr.contentView.top = (moreSelectView.top > kScreenHeight - 1)?- KMoreSelectViewHeight:0;
            moreSelectView.top = (moreSelectView.top > kScreenHeight - 1)?kScreenHeight - KMoreSelectViewHeight:kScreenHeight;
        }
    };
}

// 隐藏moreSelectView
- (void)hideMoreSelectView{
    if (self.moreSelectView.top > kScreenHeight - 1) {
        return;
    }
    self.moreSelectView.top = kScreenHeight;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView endEditing:YES];
    [self hideMoreSelectView];
    self.contentView.top = 0;
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
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}

@end
