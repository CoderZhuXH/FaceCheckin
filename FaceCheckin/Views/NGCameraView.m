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

@property (nonatomic, strong) AVCaptureSession          * currentSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput  * videoDataOutput;

////////////////////////////////////////////////// ->  Preview

@property (nonatomic, strong) AVCaptureVideoPreviewLayer    * previewLayer;
@property (nonatomic, retain) dispatch_queue_t              videoDataDispatchQueue;

- (void)didRotateInterface:(id)message;

@end

@implementation NGCameraView

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
	self.videoDataOutput = [AVCaptureVideoDataOutput new];
	
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
	NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
									   [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
	[self.videoDataOutput setVideoSettings:rgbOutputSettings];
    
    // create a serial dispatch queue used for the sample buffer delegate as well as when a still image is captured
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
	self.videoDataDispatchQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
	[_videoDataOutput setSampleBufferDelegate:self queue:self.videoDataDispatchQueue];
	
    if ( [_currentSession canAddOutput:_videoDataOutput] )
		[_currentSession addOutput:_videoDataOutput];
	[[_videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

@end
