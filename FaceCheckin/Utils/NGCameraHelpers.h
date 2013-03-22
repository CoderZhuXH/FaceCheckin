//
//  NGCameraHelpers.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/21/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NGCameraHelpers : NSObject

+ (int) numberOfCameras;
+ (BOOL) backCameraAvailable;
+ (BOOL) frontCameraAvailable;
+ (AVCaptureDevice *)backCamera;
+ (AVCaptureDevice *)frontCamera;

+ (CGAffineTransform)imageTransformForOrientation;

NSUInteger exifOrientationFromUIOrientation(UIImageOrientation);
UIImageOrientation imageOrientationFromEXIFOrientation(NSUInteger);

@end
