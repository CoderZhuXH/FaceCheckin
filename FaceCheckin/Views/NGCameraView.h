//
//  NGCameraView.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class NGCameraView;

@protocol NGCameraViewDelegate<NSObject>
@optional
- (void)cameraView:(NGCameraView *)view didTakeSnapshot:(UIImage *)image;
- (void)cameraView:(NGCameraView *)view failedTakingSnapshot:(NSError *)error;

- (void)cameraView:(NGCameraView *)view faceFoundInFrame:(CGRect)frame;

@end

typedef void(^NGCameraViewCapturedImageCallback)(UIImage * capturedImage, NSError * error);

@interface NGCameraView : UIView<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, assign) id<NGCameraViewDelegate> delegate;
@property (nonatomic, assign,setter = toggleFaceCapture:) BOOL faceCaptureEnabled;

- (void)takePicture:(NGCameraViewCapturedImageCallback)callback;
- (void)takePictureWithDelegate;

@end