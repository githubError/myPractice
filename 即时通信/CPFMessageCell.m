//
//  CPFMessageCell.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFMessageCell.h"
#import "CPFButton.h"
#import "UIViewExt.h"
#import "UIImage+XMGResizing.h"
#import "EMCDDeviceManager.h"

#define kCellPadding 10
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kWeChatAllSubviewHeight 44

@interface CPFMessageCell ()
{
    CPFButton *_iconBtn;
    CPFButton *_messageBtn;
}

@end

@implementation CPFMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconBtn = [CPFButton shareButton];
        [self addSubview:_iconBtn];
        
        _messageBtn = [CPFButton shareButton];
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        _messageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _messageBtn.titleLabel.numberOfLines = 0;
        _messageBtn.contentEdgeInsets = UIEdgeInsetsMake(5,10, 15, 10);
        [self addSubview:_messageBtn];
    }
    return self;
}

- (CGFloat)rowHeight {
    [self layoutIfNeeded];
    return _messageBtn.bottom + kCellPadding;
}

- (void)setMessage:(EMMessage *)message {
    _message = message;
    
    id messageBody = message.messageBodies[0];
    
    if ([messageBody isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textMsgBody = messageBody;
        
        CGSize realSize = [textMsgBody.text boundingRectWithSize:CGSizeMake(kScreenWidth/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
        
        _messageBtn.size = CGSizeMake(realSize.width + 40, realSize.height + 40);
        [_messageBtn setTitle:textMsgBody.text forState:UIControlStateNormal];
        [_messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_messageBtn setImage:nil forState:UIControlStateNormal];
        
    }else if ([messageBody isKindOfClass:[EMVoiceMessageBody class]]){
        EMVoiceMessageBody *voiceBody = messageBody;
        _messageBtn.size = CGSizeMake(kWeChatAllSubviewHeight + 20, kWeChatAllSubviewHeight + 20);
        [_messageBtn setTitle:[NSString stringWithFormat:@"  %zd",voiceBody.duration] forState:UIControlStateNormal];
        [_messageBtn setImage:[UIImage imageNamed:@"chat_receiver_audio_playing_full"] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([messageBody isKindOfClass:[EMImageMessageBody class]]){
        EMImageMessageBody *imgBody = messageBody;
        _messageBtn.size = CGSizeMake(kWeChatAllSubviewHeight*2 + 40, kWeChatAllSubviewHeight*2 + 40);
        // 预览图片的路径
        NSString *imgPath = imgBody.thumbnailLocalPath;
        // 判断本地图片是否存在
        NSFileManager *file = [NSFileManager defaultManager];
        // 使用SDWebImage设置图片
        NSURL *url = nil;
        if ([file fileExistsAtPath:imgPath]) {
            url = [NSURL fileURLWithPath:imgPath];
        }else{
            url = [NSURL URLWithString:imgBody.thumbnailRemotePath];
        }
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        [_messageBtn setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        [_messageBtn addTarget:self action:@selector(shadowImage) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _messageBtn.top = 30;
    
    
    if ([message.from isEqualToString:[[EaseMob sharedInstance].chatManager loginInfo][@"username"]]) {// 自己发的消息
        
        [_messageBtn setBackgroundImage:[UIImage resizingImageWithName:@"SenderTextNodeBkg"] forState:UIControlStateNormal];
        [_messageBtn setBackgroundImage:[UIImage resizingImageWithName:@"SenderTextNodeBkgHL"] forState:UIControlStateHighlighted];
        
        _messageBtn.left = kScreenWidth - 44 - _messageBtn.size.width - kCellPadding;
        _iconBtn.frame = CGRectMake(_messageBtn.right + kCellPadding/2, _messageBtn.top, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
        [_iconBtn setImage:[UIImage imageNamed:@"default_header"] forState:UIControlStateNormal];
        
    }else{
        [_messageBtn setBackgroundImage:[UIImage resizingImageWithName:@"ReceiverTextNodeBkg"] forState:UIControlStateNormal];
        [_messageBtn setBackgroundImage:[UIImage resizingImageWithName:@"ReceiverTextNodeBkgHL"] forState:UIControlStateHighlighted];
        
        _iconBtn.frame = CGRectMake(kCellPadding/2, _messageBtn.top, kWeChatAllSubviewHeight, kWeChatAllSubviewHeight);
        [_iconBtn setImage:[UIImage imageNamed:@"chatListCellHead"] forState:UIControlStateNormal];
        
        _messageBtn.left = _iconBtn.right + kCellPadding/2;
        
    }
}

// 播放语音IDeviceManagerDelegate
- (void)playAudio {
    // 获取消息体
    id msgBody = self.message.messageBodies[0];
    if ([msgBody isKindOfClass:[EMVoiceMessageBody class]]) {
        // 获取语音消息体
        EMVoiceMessageBody *voiceBody = msgBody;
        // 获取语音路径
        NSString *voicePath = voiceBody.localPath;
        
        // 如果本地没有，那么就播放远程
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:voicePath]) {
            voicePath = voiceBody.remotePath;
        }
        // 播放
        [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:voicePath completion:^(NSError *error) {
            if (!error) {
                NSLog(@"语音播放完成");
            }
        }];
    }
}

- (void)showImage
{
    if ([self.delegate respondsToSelector:@selector(cellShowImageWithMessage:)]) {
        [self.delegate cellShowImageWithMessage:self.message];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
