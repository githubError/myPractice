//
//  CPFPopoverView.m
//  即时通信
//
//  Created by cuipengfei on 16/5/18.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFPopoverView.h"
#import "UIViewExt.h"

@implementation CPFPopoverView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = CGRectMake(0, 0, 120, 80);
        
        [_addFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
        [_addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addFriendButton setImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
        _addFriendButton.frame = CGRectMake(10, 5, 100, 35);
        [_addFriendButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
        
        [_addGroupButton setTitle:@"发起群聊" forState:UIControlStateNormal];
        [_addGroupButton setImage:[UIImage imageNamed:@"contacts_add_newmessage"] forState:UIControlStateNormal];
        [_addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addGroupButton.frame = CGRectMake(10, _addFriendButton.bottom , 100, 35);
        [_addGroupButton addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_addGroupButton];
        [self addSubview:_addFriendButton];
    }
    return self;
}

- (void)addFriend {
    NSLog(@"添加好友");
}

- (void)addGroup {
    NSLog(@"发起群聊");
}

@end
