//
//  CPFCallViewController.h
//  即时通信
//
//  Created by cuipengfei on 16/5/28.
//  Copyright © 2016年 cuipengfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CPFCallViewController : UIViewController

{
    UIView *_smallView;
    OpenGLView20 *_openGLView;
    UInt8 *_imageDataBuffer;
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureOutput;

@property (nonatomic,strong)EMCallSession *m_session;

@end
