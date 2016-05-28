//
//  CPFMoreSelectView.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMoreSelectView.h"
#import "CPFButton.h"
#import "UIViewExt.h"


#define CPFMoreSelectViewBtnX 60
#define CPFMoreSelectViewBtnY 20
#define CPFMoreSelectViewBtnWidth 60
#define CPFMoreSelectViewBtnHeight 60
#define CPFMoreSelectViewBtnPadding 10

@interface CPFMoreSelectView ()
{
    CPFButton *imageBtn;
    CPFButton *callBtn;
    CPFButton *videoBtn;
}

@end

@implementation CPFMoreSelectView

- (instancetype)initWithImageBtnBlock:(void (^)(void))imageBtnBlock CallBtnBlock:(void (^)(void))callBtnBlock VideoBtnBlock:(void (^)(void))videoBtnBlock {
    if (self = [super init]) {
        imageBtn = [CPFButton shareButton];
        [imageBtn setBackgroundColor:[UIColor redColor]];
        [imageBtn setTitle:@"图片" forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        imageBtn.clickBlock = ^(CPFButton *btn){
            if (imageBtnBlock) {
                imageBtnBlock();
            }
        };
        [self addSubview:imageBtn];
        
        callBtn = [CPFButton shareButton];
        [callBtn setBackgroundColor:[UIColor redColor]];
        [callBtn setTitle:@"电话" forState:UIControlStateNormal];
        [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        callBtn.clickBlock = ^(CPFButton *btn){
            if (callBtnBlock) {
                callBtnBlock();
            }
        };
        [self addSubview:callBtn];
        
        videoBtn = [CPFButton shareButton];
        [videoBtn setBackgroundColor:[UIColor redColor]];
        [videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        [videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        videoBtn.clickBlock = ^(CPFButton *btn){
            if (videoBtnBlock) {
                videoBtnBlock();
            }
        };
        [self addSubview:videoBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    imageBtn.frame = CGRectMake(CPFMoreSelectViewBtnX, CPFMoreSelectViewBtnY, CPFMoreSelectViewBtnWidth, CPFMoreSelectViewBtnHeight);
    callBtn.frame = CGRectMake(imageBtn.right + CPFMoreSelectViewBtnPadding, CPFMoreSelectViewBtnY, CPFMoreSelectViewBtnWidth, CPFMoreSelectViewBtnHeight);
    videoBtn.frame = CGRectMake(callBtn.right + CPFMoreSelectViewBtnPadding, CPFMoreSelectViewBtnY, CPFMoreSelectViewBtnWidth, CPFMoreSelectViewBtnHeight);
}

@end
