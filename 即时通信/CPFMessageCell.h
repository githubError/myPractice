//
//  CPFMessageCell.h
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

@protocol CPFCellShowImageWithMessageDelegate <NSObject>

- (void)cellShowImageWithMessage:(EMMessage *)message;

@end

@interface CPFMessageCell : UITableViewCell

@property (nonatomic, strong) EMMessage *message;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) id<CPFCellShowImageWithMessageDelegate>delegate;

@end
