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

@interface CPFCallViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, EMCallManagerDelegate, EMCallManagerCallDelegate>
{
    UILabel *timeLabel;
}

@property (nonatomic, assign)int sendTime;
@property (nonatomic, assign)int recTime;
@property (nonatomic, weak)NSTimer *sendtimer;
@property (nonatomic, weak)NSTimer *rectimer;
@end

@implementation CPFCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendTime = 0;
    self.recTime = 0;
    
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
    acceptBtn.frame  = CGRectMake(kPadding + 40, kScreenHeight - kAllSubviewHeight*2, kAllSubviewHeight*2, kAllSubviewHeight);
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
        self.sendtimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
        [self.rectimer invalidate];
    };
    
    cancelBtn.clickBlock = ^(CPFButton *btn){
        [[EaseMob sharedInstance].callManager asyncEndCall:self.m_session.sessionId reason:eCallReasonNull];
        [self.sendtimer invalidate];
        [self.rectimer invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)startTimer
{
    self.sendTime ++;
    int hour = self.sendTime/3600;
    int min = (self.sendTime - hour * 3600)/60;
    int sec = self.sendTime - hour* 3600 - min * 60;
    
    if (hour > 0) {
        timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i",hour,min,sec];
    }else if(min > 0){
        timeLabel.text = [NSString stringWithFormat:@"%i:%i",min,sec];
    }else{
        timeLabel.text = [NSString stringWithFormat:@"00:%i",sec];
    }
}

- (void)recStartTimer
{
    self.recTime ++;
    int hour = self.recTime/3600;
    int min = (self.recTime - hour * 3600)/60;
    int sec = self.recTime - hour* 3600 - min * 60;
    
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
//    self.captureOutput.minFrameDuration = CMTimeMake(1, 15);
//    AVCaptureConnection *connection = [[AVCaptureConnection alloc] initWithInputPorts:self.inputDevice output:self.captureOutput];
    self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t outQueue = dispatch_queue_create("com.gh.cecall", NULL);
    [self.captureOutput setSampleBufferDelegate:self queue:outQueue];
    [self.session addOutput:self.captureOutput];
    [self.session commitConfiguration];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(self.view.frame.size.width - 90, 30, width, height);
    
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    [rootLayer addSublayer:self.previewLayer];
    
}

void YUV420spRotate90(UInt8 *  dst, UInt8* src, size_t srcWidth, size_t srcHeight)
{
    size_t wh = srcWidth * srcHeight;
    size_t uvHeight = srcHeight >> 1;//uvHeight = height / 2
    size_t uvWidth = srcWidth>>1;
    size_t uvwh = wh>>2;
    //旋转Y
    int k = 0;
    for(int i = 0; i < srcWidth; i++) {
        int nPos = wh-srcWidth;
        for(int j = 0; j < srcHeight; j++) {
            dst[k] = src[nPos + i];
            k++;
            nPos -= srcWidth;
        }
    }
    for(int i = 0; i < uvWidth; i++) {
        int nPos = wh+uvwh-uvWidth;
        for(int j = 0; j < uvHeight; j++) {
            dst[k] = src[nPos + i];
            dst[k+uvwh] = src[nPos + i+uvwh];
            k++;
            nPos -= uvWidth;
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (_m_session.status != eCallSessionStatusAccepted) {
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        //        UInt8 *bufferbasePtr = (UInt8 *)CVPixelBufferGetBaseAddress(imageBuffer);
        UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
        //        printf("addr diff1:%d,diff2:%d\n",bufferPtr-bufferbasePtr,bufferPtr1-bufferPtr);
        
        //        size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        //        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1);
        //        size_t bytesrow2 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 2);
        //        printf("buffeSize:%d,width:%d,height:%d,bytesPerRow:%d,bytesrow0 :%d,bytesrow1 :%d,bytesrow2 :%d\n",buffeSize,width,height,bytesPerRow,bytesrow0,bytesrow1,bytesrow2);
        
        if (_imageDataBuffer == nil) {
            _imageDataBuffer = (UInt8 *)malloc(width * height * 3 / 2);
        }
        UInt8 *pY = bufferPtr;
        UInt8 *pUV = bufferPtr1;
        UInt8 *pU = _imageDataBuffer + width * height;
        UInt8 *pV = pU + width * height / 4;
        for(int i =0; i < height; i++)
        {
            memcpy(_imageDataBuffer + i * width, pY + i * bytesrow0, width);
        }
        
        for(int j = 0; j < height / 2; j++)
        {
            for(int i = 0; i < width / 2; i++)
            {
                *(pU++) = pUV[i<<1];
                *(pV++) = pUV[(i<<1) + 1];
            }
            pUV += bytesrow1;
        }
        
        YUV420spRotate90(bufferPtr, _imageDataBuffer, width, height);
        [[EaseMob sharedInstance].callManager processPreviewData:(char *)bufferPtr width:width height:height];
        
        /*We unlock the buffer*/
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
}

- (void)dealloc
{
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}

#pragma mark - EMCallManagerCallDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error {
    if (callSession.status == eCallSessionStatusDisconnected) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (callSession.status == eCallSessionStatusAccepted) {
        self.rectimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(recStartTimer) userInfo:nil repeats:YES];
    }
}

@end
