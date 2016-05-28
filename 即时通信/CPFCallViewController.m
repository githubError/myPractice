//
//  CPFCallViewController.m
//  即时通信
//
//  Created by cuipengfei on 16/5/28.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import "CPFCallViewController.h"

@interface CPFCallViewController ()

@end

@implementation CPFCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     1、定义会话
     2、为会话指定captureDevice
     3、获取captureDevice的inputDevice
     4、将inputDevice添加到session上
     
     5、定义previewLayer取景器
     
     */
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetLow];
    
    self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    self.inputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice error:&error];
    
    if ([self.session canAddInput:self.inputDevice]) {
        [self.session addInput:self.inputDevice];
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.previewLayer.frame = CGRectMake(0, 0, 300, 400);
    
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    [rootLayer addSublayer:self.previewLayer];
    
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
