//
//  NGCameraView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraView.h"

@interface NGCameraView ()

////////////////////////////////////////////////// -> Video Specifics

@property (nonatomic, strong) AVCaptureSession               * currentSession;
@property (nonatomic, strong) AVCaptureStillImageOutput      * stillCapture;
@property (nonatomic, strong) dispatch_queue_t              captureQueue;

////////////////////////////////////////////////// ->  Preview

@property (nonatomic, strong) AVCaptureVideoPreviewLayer    * previewLayer;
@property (nonatomic, strong) UIImage                       *returnPicture;

////////////////////////////////////////////////// ->  Take a shot

@property (nonatomic, copy
           ) NGCameraViewCapturedImageCallback callback;

- (void)didRotateInterface:(id)message;

@end

@implementation NGCameraView {
    BOOL letsNotTriggerIt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEveryThing];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupEveryThing];
}

- (void)setupEveryThing {
    NSError *error = nil;
    
#pragma mark - Setup Rotation Yeah!

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotateInterface:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
#pragma mark - End Pragma
    
    self.currentSession = [AVCaptureSession new];
    [self.currentSession setSessionPreset:AVCaptureSessionPresetHigh];
	
    // Select a video device, make an input
    
    AVCaptureDevice *device = nil;
    for (AVCaptureDevice * challenger in [AVCaptureDevice devices]) {
        if (challenger.position == AVCaptureDevicePositionFront) {
            device = challenger;
            break;
        }
    }
    
    NSAssert(device != nil, @"Device cannot be nil here.");
    
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
	if ( [self.currentSession canAddInput:deviceInput] )
		[self.currentSession addInput:deviceInput];

    // Make a video data output
	self.stillCapture = [AVCaptureStillImageOutput new];
    self.captureQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);

	
    if ( [_currentSession canAddOutput:self.stillCapture ])
		[_currentSession addOutput:self.stillCapture ];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_currentSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    _previewLayer.frame = self.bounds;
    [self.layer addSublayer:_previewLayer];
    
    // inital sh1t
    [self didRotateInterface:nil];
    
	[self.currentSession startRunning];
}

- (void)didRotateInterface:(id)message {
    
    switch ([UIDevice currentDevice].orientation)
    {
        case UIInterfaceOrientationLandscapeRight:
            [self.previewLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self.previewLayer setAffineTransform:CGAffineTransformMakeRotation(M_PI / 2)];
            break;
        default:
            // DO NOTHING
            break;
    }
    
    _previewLayer.frame = self.bounds;
}

- (void)takePicture:(NGCameraViewCapturedImageCallback)callback {
    
    if (self.callback) {
        return;
    }
    
    self.callback = callback;
    [self _reallyTakePicture];
    
}

- (void)returnImage:(UIImage *)image withError:(NSError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callback(image,err);
        self.callback = nil;
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
	AVCaptureVideoOrientation result = deviceOrientation;
	if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
		result = AVCaptureVideoOrientationLandscapeRight;
	else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
		result = AVCaptureVideoOrientationLandscapeLeft;
	return result;
}

- (void)_reallyTakePicture {

    NSLog(@"Called... how many times?");
    
    AVCaptureConnection *stillImageConnection = [self.stillCapture connectionWithMediaType:AVMediaTypeVideo];
    
    NSDictionary * prefs = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.stillCapture setOutputSettings:prefs];
    
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
	AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
	[stillImageConnection setVideoOrientation:avcaptureOrientation];
    
    [self.stillCapture captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer == nil) return;
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * resultImage = [[UIImage alloc] initWithData:jpegData];
        [self returnImage:resultImage withError:error];        
    }];
}

@end
