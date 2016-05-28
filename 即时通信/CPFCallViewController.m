//
//  CPFCallViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/28.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFCallViewController.h"
#import "CPFButton.h"

#define kPadding 10
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kAllSubviewHeight 44

@interface CPFCallViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, EMCallManagerDelegate>
{
    UILabel *timeLabel;
}

@property (nonatomic, assign)int time;
@property (nonatomic, weak)NSTimer *timer;

@end

@implementation CPFCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.time = 0;
    
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"callBg.png"];
    bgView.frame  =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:bgView];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    
    timeLabel = [[UILabel alloc]init];
    timeLabel.frame = CGRectMake(0, kAllSubviewHeight, kScreenWidth, kAllSubviewHeight);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:timeLabel];
    
    CPFButton *acceptBtn = [CPFButton shareButton];
    acceptBtn.frame  = CGRectMake(kPadding, kScreenHeight - kAllSubviewHeight*2, kAllSubviewHeight*2, kAllSubviewHeight);
    [acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    acceptBtn.backgroundColor = [UIColor grayColor];
    [contentView addSubview:acceptBtn];
    
    
    CPFButton *cancelBtn = [CPFButton shareButton];
    cancelBtn.frame  = CGRectMake(kScreenWidth - kAllSubviewHeight - kPadding - kAllSubviewHeight*2, kScreenHeight - kAllSubviewHeight*2, kAllSubviewHeight*2, kAllSubviewHeight);
    [cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor grayColor];
    [contentView addSubview:cancelBtn];
    
    if (self.m_session.type == eCallSessionTypeVideo) {
        // 初始化
        [self initCamera];
        // 开始会话
        [self.session startRunning];
        // 将按钮显示在屏幕的最前面
        [self.view bringSubviewToFront:contentView];
        // 视频时对方的图像显示区域
        self.m_session.displayView = _openGLView;
    }
    
    acceptBtn.clickBlock = ^(CPFButton *btn){
        
        [[EaseMob sharedInstance].callManager asyncAnswerCall:self.m_session.sessionId];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    };
    
    cancelBtn.clickBlock = ^(CPFButton *btn){
        [[EaseMob sharedInstance].callManager asyncEndCall:self.m_session.sessionId reason:eCallReasonNull];
        [self.timer invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)startTimer
{
    self.time ++;
    int hour = self.time/3600;
    int min = (self.time - hour * 3600)/60;
    int sec = self.time - hour* 3600 - min * 60;
    
    if (hour > 0) {
        timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i",hour,min,sec];
    }else if(min > 0){
        timeLabel.text = [NSString stringWithFormat:@"%i:%i",min,sec];
    }else{
        timeLabel.text = [NSString stringWithFormat:@"00:%i",sec];
    }
}

- (void)initCamera {
    /**
     1、定义会话
     2、为会话指定captureDevice
     3、获取captureDevice的inputDevice
     4、将inputDevice添加到session上
     
     5、定义previewLayer取景器
     
     */
    
    
    // 大视图
    _openGLView = [[OpenGLView20 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _openGLView.backgroundColor = [UIColor clearColor];
    _openGLView.sessionPreset = AVCaptureSessionPreset352x288;
    [self.view addSubview:_openGLView];
    
    // 小视图
    CGFloat width = 80;
    CGFloat height = _openGLView.frame.size.height / _openGLView.frame.size.width * width;
    _smallView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 50, width, height)];
    _smallView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_smallView];
    
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    self.inputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
    
    if ([self.session canAddInput:self.inputDevice]) {
        [self.session addInput:self.inputDevice];
    }
    
    self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.captureOutput.videoSettings = _openGLView.outputSettings;
    self.captureOutput.minFrameDuration = CMTimeMake(1, 15);
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t outQueue = dispatch_queue_create("com.gh.cecall", NULL);
    [self.captureOutput setSampleBufferDelegate:self queue:outQueue];
    [self.session addOutput:self.captureOutput];
    [self.session commitConfiguration];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, width, height);
    
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    [rootLayer addSublayer:self.previewLayer];
    
}

- (void)dealloc
{
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

@end
