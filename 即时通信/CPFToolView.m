//
//  CPFToolView.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFToolView.h"
#import "UIViewExt.h"

@implementation CPFToolView 


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
        // 初始化控件
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CGRectMake(0, 0, 40, 40);
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [_recordBtn setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
        [self addSubview:_recordBtn];
        
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(_recordBtn.right, 0, 240, 40)];
        [_inputView setBackgroundColor:[UIColor whiteColor]];
        _inputView.layer.cornerRadius = 6.0;
        _inputView.layer.borderWidth = 1.0;
        _inputView.layer.borderColor = [UIColor whiteColor].CGColor;
        _inputView.returnKeyType = UIReturnKeySend;
        [self addSubview:_inputView];
        
        _moreSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreSelectBtn.frame = CGRectMake(_inputView.right, 0, 40, 40);
        [_moreSelectBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreSelectBtn setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtnHL_Black"] forState:UIControlStateHighlighted];
        [self addSubview:_moreSelectBtn];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    _inputView.height = textView.contentSize.height;
    self.height = _inputView.height;
}
@end
