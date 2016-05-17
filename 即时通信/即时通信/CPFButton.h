//
//  CPFButton.h
//  即时通信
//
//  Created by cuipengfei on 16/5/17.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CPFButtonClickBlock)(id);

@interface CPFButton : UIButton

@property (nonatomic, strong) CPFButtonClickBlock clickBlock;

+ (instancetype)shareButton;

@end
