//
//  CPFToolView.h
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFToolView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *moreSelectBtn;
@property (nonatomic, strong) UIButton *sendTalkBtn;

@end
