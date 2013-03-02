//
//  NGCameraView.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^NGCameraViewCapturedImageCallback)(UIImage * capturedImage, NSError * error);

@interface NGCameraView : UIView

- (void)takePicture:(NGCameraViewCapturedImageCallback)callback;

@end