//
//  CPFMoreSelectView.h
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFMoreSelectView : UIView

- (instancetype)initWithImageBtnBlock:(void(^)(void))imageBtnBlock CallBtnBlock:(void(^)(void))callBtnBlock VideoBtnBlock:(void(^)(void))videoBtnBlock;

@end
