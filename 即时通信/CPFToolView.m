//
//  CPFToolView.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFToolView.h"
#import "UIViewExt.h"
#import "TKAlertCenter.h"

@interface CPFToolView ()
{
    __weak UIButton *weakRecordBtn;
    __weak UITextView *weakInputView;
}

@end

@implementation CPFToolView 


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        // 初始化控件
        _recordBtn = [CPFButton shareButton];
        _recordBtn.frame = CGRectMake(0, 0, 40, 40);
        _recordBtn.contentMode = UIViewContentModeScaleAspectFill;
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [_recordBtn addTarget:self action:@selector(showRecordBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_recordBtn];
        
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(_recordBtn.right, 5, 240, 30)];
        [_inputView setBackgroundColor:[UIColor whiteColor]];
        _inputView.layer.cornerRadius = 6.0;
        _inputView.layer.borderWidth = 1.0;
        _inputView.layer.borderColor = [UIColor whiteColor].CGColor;
        _inputView.delegate = self;
        _inputView.returnKeyType = UIReturnKeySend;
        [self addSubview:_inputView];
        
        _moreSelectBtn = [CPFButton shareButton];
        _moreSelectBtn.frame = CGRectMake(_inputView.right, 0, 40, 40);
        _moreSelectBtn.contentMode = UIViewContentModeScaleAspectFill;
        [_moreSelectBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreSelectBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [self addSubview:_moreSelectBtn];
        // _moreSelectBtn点击事件
        __weak CPFToolView *weakSelf = self;
        _moreSelectBtn.clickBlock = ^(CPFButton *btn){
            if (weakSelf.moreBtnBlock) {
                weakSelf.moreBtnBlock();
            }
        };
        
        _sendTalkBtn = [CPFButton shareButton];
        _sendTalkBtn.frame = CGRectMake(_recordBtn.right, 5, 240, 30);
        [_sendTalkBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        _sendTalkBtn.backgroundColor = [UIColor whiteColor];
        _sendTalkBtn.layer.cornerRadius = 6.0;
        [_sendTalkBtn setTitle:@"松手 发送" forState:UIControlStateHighlighted];
        [_sendTalkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendTalkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_sendTalkBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchDown];
        [_sendTalkBtn addTarget:self action:@selector(stop:) forControlEvents:UIControlEventTouchUpInside];
        [_sendTalkBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpOutside];
        [_sendTalkBtn setHidden:YES];
        [self addSubview:_sendTalkBtn];
    }
    return self;
}

// 显示录音按钮
- (void)showRecordBtn {
    static BOOL isShowRecod = YES;
    if (isShowRecod) {
        _sendTalkBtn.hidden = NO;
        isShowRecod = NO;
    }else {
        _sendTalkBtn.hidden = YES;
        isShowRecod = YES;
    }
}

// 开始录音
- (void)start:(CPFButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewRecord:withType:)]) {
        [self.delegate toolViewRecord:btn withType:CPFToolViewRecordStart];
    }
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"开始录音"];
}

// 结束录音
- (void)stop:(CPFButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewRecord:withType:)]) {
        [self.delegate toolViewRecord:btn withType:CPFToolViewRecordStop];
    }
}

// 退出录音
- (void)cancel:(CPFButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolViewRecord:withType:)]) {
        [self.delegate toolViewRecord:btn withType:CPFToolViewRecordCancel];
    }
    [[TKAlertCenter defaultCenter] postAlertWithMessage:@"录音已取消"];
}


#pragma mark - UITextViewDelegate
// 动态改变输入框文本高度
//- (void)textViewDidChange:(UITextView *)textView {
//    _inputView.height = textView.contentSize.height;
//    self.height = _inputView.height;
//    if ([textView.text hasSuffix:@"\n"]) {
//        if (_textFieldSendBlock) {
//            _textFieldSendBlock(textView);
//        }
//        [textView resignFirstResponder];
//    }
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        if (_textFieldSendBlock) {
            _textFieldSendBlock(textView);
        }
        _inputView.text = @"";
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_beginEditBlock) {
        _beginEditBlock(textView);
    }
}

@end
