//
//  NGCameraHelpers.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/21/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraHelpers.h"

@implementation NGCameraHelpers

+ (int) numberOfCameras {
    return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
}

+ (BOOL) backCameraAvailable {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionBack) return YES;
    }
    return NO;
}

+ (BOOL) frontCameraAvailable {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices) {
        if (device.position == AVCaptureDevicePositionFront) {
            return YES;
        }
    }
    return NO;
}

+ (AVCaptureDevice *)backCamera
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            return device;
        }
    }
    
    // Return whatever is available if there's no back camera
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

+ (AVCaptureDevice *)frontCamera
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            return device;
        }
    }
    
    // Return whatever device is available if there's no back camera
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

+ (CGAffineTransform)imageTransformForOrientation {
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform t = CGAffineTransformIdentity;
    
    if (curDeviceOrientation == UIDeviceOrientationPortrait) {
        t = CGAffineTransformMakeRotation(-M_PI / 2);
    } else if (curDeviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        t = CGAffineTransformMakeRotation(M_PI / 2);
    } else if (curDeviceOrientation == UIDeviceOrientationLandscapeRight) {
        t = CGAffineTransformMakeRotation(0);
    } else {
        t = CGAffineTransformMakeRotation(M_PI);
    }
    
    return t;
}

NSUInteger exifOrientationFromUIOrientation(UIImageOrientation uiorientation)
{
    if (uiorientation > 7) return 1;
    int orientations[8] = {1, 3, 6, 8, 2, 4, 5, 7};
    return orientations[uiorientation];
}

UIImageOrientation imageOrientationFromEXIFOrientation(NSUInteger exiforientation)
{
    if ((exiforientation < 1) || (exiforientation > 8))
    {
        return UIImageOrientationUp;
    }
    int orientations[8] = {0, 4, 1, 5, 6, 2, 7, 3};
    return orientations[exiforientation];
}

@end
