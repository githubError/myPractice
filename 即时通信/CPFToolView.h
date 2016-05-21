//
//  CPFToolView.h
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CPFToolViewRecordStart,
    CPFToolViewRecordStop,
    CPFToolViewRecordCancel
}CPFToolViewRecordType;

typedef void(^CPFToolViewMoreBtnBlock)();
// 发送文字
typedef void(^CPFToolViewTextFieldSendBlock)(UITextView *);
// 开始编辑
typedef void(^CPFToolViewTextFieldBeginEditBlock)(UITextView *);

@protocol CPFToolViewRecordDelegate <NSObject>

- (void)toolViewRecord:(UIButton *)recordBtn withType:(CPFToolViewRecordType)type;

@end

@interface CPFToolView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UITextView *inputView;
@property (nonatomic, strong) UIButton *moreSelectBtn;
@property (nonatomic, strong) UIButton *sendTalkBtn;

@property (nonatomic,assign)id<CPFToolViewRecordDelegate> delegate;
@property (nonatomic, copy)CPFToolViewTextFieldSendBlock textFieldSendBlock;

@property (nonatomic, copy)CPFToolViewTextFieldBeginEditBlock beginEditBlock;

@property (nonatomic,copy)CPFToolViewMoreBtnBlock moreBtnBlock;

@end
