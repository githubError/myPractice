//
//  CPFDialogViewController.h
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPFContentView.h"
#import "EaseMob.h"

@interface CPFDialogViewController : UIViewController <EMChatManagerDelegate>

@property (nonatomic, strong) CPFContentView *contentView;

@property (nonatomic, strong) EMBuddy *buddy;

@end
