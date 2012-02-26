//
//  CaptureBarCodeViewController.h
//  DataMatrixBarCode
//
//  Created by saurav sinha on 25/02/12.
//  Copyright (c) 2012 sauravsinha007@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CaptureSessionManager.h"

@interface CaptureBarCodeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;
    UIView *previewView;
    UIImage *imgBar;
    AVCaptureVideoPreviewLayer *previewLayer;
    AVCaptureVideoDataOutput* videoOutput;
    UIActivityIndicatorView *activitity;
    NSTimer *timer;
    IBOutlet UIView *aView;
}
@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@end
