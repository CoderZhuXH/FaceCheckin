//
//  NGCameraView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraView.h"
#import "UIImage+NGExtensions.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface NGCameraView ()

////////////////////////////////////////////////// -> Video Specifics

@property (nonatomic, strong) AVCaptureSession              * currentSession;
@property (nonatomic, strong) AVCaptureStillImageOutput     * stillCapture;
@property (nonatomic, strong) AVCaptureVideoDataOutput      * videoDataOutput;
@property (nonatomic, strong) dispatch_queue_t              captureQueue;

////////////////////////////////////////////////// ->  Preview

@property (nonatomic, strong) AVCaptureVideoPreviewLayer    * previewLayer;
@property (nonatomic, strong) UIImage                       * returnPicture;

@property (nonatomic, strong) UIImageView                   * capturingImageView;
@property (nonatomic, strong) UIImageView                   * imageWithFace;
@property (nonatomic, strong) UIImageView                   * faceRectangle;

////////////////////////////////////////////////// ->  Take a shot

@property (nonatomic, copy) NGCameraViewCapturedImageCallback callback;
@property (nonatomic, strong) CIDetector                    *faceDetector;

- (void)didRotateInterface:(id)message;

@end

@implementation NGCameraView {
    BOOL letsNotTriggerIt;
    
    BOOL _operationUnderWay;
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
//    self.capturingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width * 0.6, self.bounds.size.height * 0.6, self.bounds.size.width * 0.4, self.bounds.size.height * 0.4)];
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
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
    
#if TARGET_IPHONE_SIMULATOR
    return;
#else
    NSAssert(device != nil, @"Device cannot be nil here.");
#endif
    
	AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
	if ( [self.currentSession canAddInput:deviceInput] )
		[self.currentSession addInput:deviceInput];

    // Make a video data output
	self.stillCapture = [AVCaptureStillImageOutput new];
    self.captureQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);

    
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
	NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
									   [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [self.videoDataOutput setVideoSettings:rgbOutputSettings];
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
	
    if ( [_currentSession canAddOutput:self.stillCapture ])
		[_currentSession addOutput:self.stillCapture ];
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_currentSession];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    _previewLayer.frame = self.bounds;
    [self.layer addSublayer:_previewLayer];
    
    // inital sh1t
    [self didRotateInterface:nil];
    
    [self addSubview:self.capturingImageView];
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

- (void)toggleFaceCapture:(BOOL)faceCaptureEnabled {
    
    [self.currentSession beginConfiguration];
    
    _faceCaptureEnabled = faceCaptureEnabled;
    
    if (![self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo].enabled) {
        [self enableStream:YES];
    }

    [self.currentSession commitConfiguration];
}

- (void)enableStream:(BOOL)shouldEnable {
    
    if (shouldEnable) {
        if ([_currentSession canAddOutput:self.videoDataOutput]) {
            [_currentSession addOutput:self.videoDataOutput];
            [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        }
    } else {
        [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:NO];
        [_currentSession removeOutput:self.videoDataOutput];
    }
}

- (void)takePicture:(NGCameraViewCapturedImageCallback)callback {
    
    if(_operationUnderWay) return;
    
    if (self.callback) {
        return;
    }
    
    self.callback = callback;
    [self _reallyTakePicture];
}

- (void)takePictureWithDelegate {
    
    if(_operationUnderWay) return;
    
    if(!self.delegate) {
        NSLog(@"Delegate not found, aborting");
        return;
    }
#pragma mark - Delegate version
    [self takePicture:^(UIImage *capturedImage, NSError *error) {
        if(!error) {
            if([self.delegate respondsToSelector:@selector(cameraView:didTakeSnapshot:)]) {
                [self.delegate cameraView:self didTakeSnapshot:capturedImage];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(cameraView:failedTakingSnapshot:)]) {
                [self.delegate cameraView:self failedTakingSnapshot:error];
            }
        }
    }];
#pragma mark -
}

- (void)returnImage:(UIImage *)image withError:(NSError *)err {
    self.callback(image,err);
    self.callback = nil;
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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    /* Checkings */
    if(!self.faceCaptureEnabled) return;
    if(_operationUnderWay) return;
    
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage * image = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    CGAffineTransform t;
    
    if (curDeviceOrientation == UIDeviceOrientationPortrait) {
        t = CGAffineTransformMakeRotation(-M_PI / 2);
    } else if (curDeviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        t = CGAffineTransformMakeRotation(M_PI / 2);
    } else if (curDeviceOrientation == UIDeviceOrientationLandscapeRight) {
        t = CGAffineTransformMakeRotation(0);
    } else {
        t = CGAffineTransformMakeRotation(M_PI);
    }
    
    image = [image imageByApplyingTransform:CGAffineTransformScale(t, -1, 1)];
    image = [image imageByApplyingTransform:CGAffineTransformMakeTranslation(-image.extent.origin.x, -image.extent.origin.y)];

    // I know the image is rotated!
    NSArray * feats = [self.faceDetector featuresInImage:image];

    dispatch_sync(dispatch_get_main_queue(), ^{
        [self drawFeatures:feats inRectangle:self.previewLayer.bounds withAperture:image.extent.size];
    });
}

- (void)drawFeatures:(NSArray *)features inRectangle:(CGRect)rect withAperture:(CGSize)apertureSize {
    if (!self.faceRectangle) {
        self.faceRectangle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FaceBox"]];
        [self.faceRectangle setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.faceRectangle];
    }
    
    CGRect newFrame;
    CGSize deltas = [[self class] multipliersForViewport:rect.size originalSize:apertureSize];
    
    for (CIFaceFeature * feat in features) {
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1, -1);
        transform = CGAffineTransformTranslate(transform, 0, -apertureSize.height);
        CGRect feature = CGRectApplyAffineTransform(feat.bounds, transform);
        
        newFrame.origin.x       =  feature.origin.x     * deltas.width;
        newFrame.origin.y       =  feature.origin.y     * deltas.height;
        newFrame.size.height    =  feature.size.height  * deltas.height * 0.66;
        newFrame.size.width     =  feature.size.width   * deltas.width * 0.66;
    }

    if(features.count == 0) {
        [self.delegate cameraView:self faceFoundInFrame:CGRectZero];
    } else {
        if([self.delegate respondsToSelector:@selector(cameraView:faceFoundInFrame:)]) {
            [self.delegate cameraView:self faceFoundInFrame:newFrame];
        }
    }
    
    self.faceRectangle.frame = newFrame;
}

- (void)_reallyTakePicture {
    
    if(_operationUnderWay) return;
    
    _operationUnderWay = YES;

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
        resultImage = [resultImage fixOrientation];
        
        UIImageWriteToSavedPhotosAlbum(resultImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        [self returnImage:resultImage withError:error];
        _operationUnderWay = NO;
    }];
}

- (void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error) {
        NSLog(@"Error happened...! %@", [error description]);
    }
}

+ (CGSize)multipliersForViewport:(CGSize)viewportSize originalSize:(CGSize)size {
    
    float ratio = size.width / size.height;
    
    CGSize result;
    
    if (ratio > 1) {
        CGFloat newWidth = ratio * viewportSize.width;
        CGFloat newHeight = viewportSize.height;
        
        CGFloat widthFactor = newWidth / size.width;
        CGFloat heightFactor = newHeight / size.height;
        
        result.width = widthFactor;
        result.height = heightFactor;
        
    }
    else {
        CGFloat newWidth = viewportSize.width;
        CGFloat newHeight = viewportSize.height / ratio;
        
        CGFloat widthFactor = newWidth / size.width;
        CGFloat heightFactor = newHeight / size.height;
        
        result.width = widthFactor;
        result.height = heightFactor;
    }
    
    return result;
}

@end
