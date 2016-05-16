//
//  CPFMessageListViewCell.h
//  即时通信
//
//  Created by cuipengfei on 16/5/16.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPFMessageListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
