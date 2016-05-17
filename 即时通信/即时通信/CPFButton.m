//
//  CPFButton.m
//  即时通信
//
//  Created by cuipengfei on 16/5/17.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFButton.h"

@implementation CPFButton

+ (instancetype)shareButton {
    return [CPFButton buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //给按钮加一个白色的板框
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.borderWidth = 1.0f;
        
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(CPFButton *)btn {
    if (self.clickBlock) {
        self.clickBlock(btn);
    }
}

@end
