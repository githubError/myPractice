//
//  CPFDialogViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/21.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFDialogViewController.h"
#import "CPFToolView.h"
#import "UIViewExt.h"
#import "CPFMoreSelectView.h"
#import "CPFMessageCell.h"
#import "MWPhotoBrowser.h"
#import "EMCDDeviceManager.h"
#import "CPFCallViewController.h"

#define KMoreSelectViewHeight 100

#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define IS_HOTSPOT_CONNECTED (APP_STATUSBAR_HEIGHT == 40) ? YES : NO

@interface CPFDialogViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, EMCallManagerDelegate, CPFCellShowImageWithMessageDelegate, MWPhotoBrowserDelegate, IEMChatProgressDelegate, UIImagePickerControllerDelegate, EMChatManagerDelegate, CPFToolViewRecordDelegate,UINavigationControllerDelegate, EMCallManagerCallDelegate>
{
    UITableView *_tableView;
    CPFToolView *_toolView;
    NSMutableArray *_allMessages;
    CGFloat _rowHeight;
    EMMessage *imageMsg;
    UIImagePickerController *imagePicker;
}

@property (nonatomic, weak) CPFMoreSelectView *moreSelectView;
@property (nonatomic,weak) UITextView *textView;

@end

@implementation CPFDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏标题
    self.title = _buddy.username;
    
    // 初始化添加内容的view
    CPFContentView *contentView = [[CPFContentView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    // 初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 104) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.contentView addSubview:_tableView];
    
    if (IS_HOTSPOT_CONNECTED ) { // 是否有个人热点开启
        // 初始化toolView
        _toolView = [[CPFToolView alloc] initWithFrame:CGRectMake(0, _tableView.bottom - 20, kScreenWidth, 40)];
    }else {
        // 初始化toolView
        _toolView = [[CPFToolView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, kScreenWidth, 40)];
    }
    
    _toolView.delegate = self;
    
    // 确定会话类型
    EMConversationType conversationType = eConversationTypeChat;
    
    NSString *chatter = self.buddy.username;
    
    // 建立会话
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:conversationType];
    
    NSArray *messages = [conversation loadAllMessages];
    _allMessages = [NSMutableArray arrayWithArray:messages];
    
    __block CPFDialogViewController *dialogViewCtr = self;
    __block NSMutableArray *arr = _allMessages;
    __block UITableView *tableView = _tableView;
    
    _toolView.beginEditBlock = ^(UITextView *textView) {
        [dialogViewCtr hideMoreSelectView];
        dialogViewCtr.textView = textView;
    };
    _toolView.textFieldSendBlock = ^(UITextView *textView){
        // 创建一个文本消息实例
        EMChatText *chatText = [[EMChatText alloc]initWithText:[textView.text substringToIndex:textView.text.length]];
        
        // 创建一个消息体
        EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithChatObject:chatText];
        
        NSString *receiver = dialogViewCtr.buddy.username;
        
        // 创建一个消息对象
        EMMessage *msg = [[EMMessage alloc]initWithReceiver:receiver bodies:@[body]];
        
        // 指定消息类型
        msg.messageType = eMessageTypeChat;
        
        [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:nil prepare:^(EMMessage *message, EMError *error) {
            NSLog(@"即将发送消息");
        } onQueue:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                NSLog(@"发送消息成功");
                [arr addObject:message];
                [tableView reloadData];
                textView.text = @"";
                [dialogViewCtr scrollLastRow];
            }
        } onQueue:nil];
    };
    
    [self.contentView addSubview:_toolView];
    
    // 初始化moreSelectView
    CPFMoreSelectView *moreSelectView = [[CPFMoreSelectView alloc] initWithImageBtnBlock:^{
        NSLog(@"---点击了图片按钮");
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = dialogViewCtr;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [dialogViewCtr presentViewController:imagePicker animated:YES completion:nil];
        
    } CallBtnBlock:^{
        NSLog(@"---点击了电话按钮");
        
        // 电话聊天
        [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:self.buddy.username timeout:50 error:nil];
    } VideoBtnBlock:^{
        NSLog(@"---点击了视频按钮");
        
        // 视频聊天
        [[EaseMob sharedInstance].callManager asyncMakeVideoCall:self.buddy.username timeout:50 error:nil];
    }];
    moreSelectView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, KMoreSelectViewHeight);
    self.moreSelectView = moreSelectView;
    [[UIApplication sharedApplication].keyWindow addSubview:moreSelectView];
    
    
    // 注册键盘弹出是Frame改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // inputView的moreSelectBtn点击事件
    _toolView.moreBtnBlock = ^(){
        if (dialogViewCtr.textView.isFirstResponder) {
            [dialogViewCtr.textView resignFirstResponder];
            moreSelectView.top = kScreenHeight - KMoreSelectViewHeight;
            dialogViewCtr.contentView.top = - KMoreSelectViewHeight;
        }else{
            dialogViewCtr.contentView.top = (moreSelectView.top > kScreenHeight - 1)?- KMoreSelectViewHeight:0;
            moreSelectView.top = (moreSelectView.top > kScreenHeight - 1)?kScreenHeight - KMoreSelectViewHeight:kScreenHeight;
        }
    };
    
    // 滚动到tableView的底部
    [self scrollLastRow];
    
    // 设置代理
    [self setChatDelegate];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];

}

- (void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
    self.title = buddy.username;
}

/*
 * 滚动到最后一行
 */
- (void)scrollLastRow
{
    // 滚动到tableView的底部
    if (_allMessages.count != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessages.count - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// 隐藏moreSelectView
- (void)hideMoreSelectView{
    if (self.moreSelectView.top > kScreenHeight - 1) {
        return;
    }else {
        self.moreSelectView.top = kScreenHeight;
    }
}

- (void)setChatDelegate
{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.contentView endEditing:YES];
    [self hideMoreSelectView];
    self.contentView.top = 0;
}

#pragma mark - 图片选择器

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image"];
    
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:chatImage];
    
    NSArray *bodyArr = [NSArray arrayWithObject:body];
    
    EMMessage *msg = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:bodyArr];
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msg progress:self prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送图片");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"图片发送成功");
            [_allMessages addObject:message];
            [_tableView reloadData];
            [self scrollLastRow];
        }
    } onQueue:nil];
}

// 接收到好友消息
- (void)didReceiveMessage:(EMMessage *)message
{
    NSLog(@"message =====%@",message);
    // 判断是不是当前好友
    if (![message.from isEqualToString:self.buddy.username]) return;
    
    // 判断消息类型
    // 单聊、群聊、聊天室
    if (message.messageType != eMessageTypeChat) return;
    
    id body = [message.messageBodies firstObject];
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        
        NSLog(@"text = %@ message = %@",textBody.text,textBody.message);
        
        [_allMessages addObject:textBody.message];
        // 刷新表格
        [_tableView reloadData];
        
        [self scrollLastRow];
        
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]) {
        EMVoiceMessageBody *voiceBody = body;
        [_allMessages addObject:voiceBody.message];
        
        [_tableView reloadData];
        
        [self scrollLastRow];
    }
    
}

#pragma mark - CPFToolViewRecordDelegate
- (void)toolViewRecord:(CPFButton *)recordBtn withType:(CPFToolViewRecordType)type
{
    if (type == CPFToolViewRecordStart) {
        NSLog(@"正在录音");
        // 根据时间生成文件名
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
            if (!error) {
                NSLog(@"====正在录音 %@",fileName);
            }
        }];
    }else if(type == CPFToolViewRecordStop){
        
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            NSLog(@"====录音完成 %@",recordPath);
            if (!error) {
                // 将消息发送给好友
                [self sendVoiceWithFileName:recordPath duration:aDuration];
            }
        }];
    }else{
        NSLog(@"录音失败");
    }
}

// 将语音消息发送给好友
- (void)sendVoiceWithFileName:(NSString *)fileName duration:(NSInteger)aDuration
{
    // 创建一个聊天语音对象
    EMChatVoice *chatVoice = [[EMChatVoice alloc]initWithFile:fileName displayName:@"[Audio]"];
    // 语音的时长
    chatVoice.duration = aDuration;
    
    // 创建一个语音消息体对象
    EMVoiceMessageBody *voiceBody = [[EMVoiceMessageBody alloc]initWithChatObject:chatVoice];
    
    // 创建一个消息对象
    EMMessage *msgObj = [[EMMessage alloc]initWithReceiver:self.buddy.username bodies:@[voiceBody]];
    
    //    msgObj.messageType = eMessageTypeGroupChat;
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:msgObj progress:self prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送语音");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            NSLog(@"语音发送成功");
            [_allMessages addObject:message];
            [_tableView reloadData];
            [self scrollLastRow];
        }else{
            NSLog(@"语音发送失败");
        }
    } onQueue:nil];
    
}

// UIKeyboardWillChangeFrameNotification响应方法, 解决弹出键盘遮盖输入框问题
- (void)keyboardWillChangeFrame:(NSNotification *)noti
{
    CGRect endRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect contentF = self.contentView.frame;
    
    if (kScreenHeight - endRect.origin.y == 0) {
        contentF.origin.y = 0;
    }else{
        contentF.origin.y = -(endRect.size.height);
    }
    self.contentView.frame = contentF;
}


#pragma mark - UITableView 数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatCell";
    CPFMessageCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CPFMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.message = _allMessages[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"chatCell";
    CPFMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CPFMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.message = _allMessages[indexPath.row];
    
    return cell.rowHeight;
}

#pragma mark - 展示图片
- (void)cellShowImageWithMessage:(EMMessage *)message {
    imageMsg = message;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    EMImageMessageBody *body = imageMsg.messageBodies[0];
    // 预览图片的路径
    NSString *imgPath = body.localPath;
    // 判断本地图片是否存在
    NSFileManager *file = [NSFileManager defaultManager];
    // 使用SDWebImage设置图片
    NSURL *url = nil;
    if ([file fileExistsAtPath:imgPath]) {
        return [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:imgPath]];
    }else{
        url = [NSURL URLWithString:body.remotePath];
        return [MWPhoto photoWithURL:url];
        
    }
}

- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody
{
    NSLog(@"进度为%f",progress);
}

#pragma mark - EMCallManagerCallDelegate
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (callSession.status == eCallSessionStatusConnected) {
        
        CPFCallViewController *callViewCtr = [[CPFCallViewController alloc] init];
        // 将当前的会话传到下一个界面进行处理
        callViewCtr.m_session = callSession;
        [self presentViewController:callViewCtr animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideMoreSelectView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideMoreSelectView];
}

@end
