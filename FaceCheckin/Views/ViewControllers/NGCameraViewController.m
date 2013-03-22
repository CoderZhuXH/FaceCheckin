//
//  NGCameraViewController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraViewController.h"
#import "UILabel+NGExtensions.h"

#import "NSDate+NGExtensions.h"

#import "NGUserPanelController.h"

#define ScreenSaverNSTimeIntervalTimeout 30.0f

@interface NGCameraViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alignFaceLabel;
@property (weak, nonatomic) IBOutlet NGCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *faceSquareView;

@property (strong, nonatomic) NSTimer * capturingIn;

@property (nonatomic, strong) NSDate * screensaverDate;

- (void)longPressToLoad:(id)someData;

@end

@implementation NGCameraViewController {
    NSDate * _startedCapturing;
    BOOL stillInImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cameraView.delegate = self;
    
    [self.alignFaceLabel fitTextToWidth:self.alignFaceLabel.frame.size.width forFontName:@"GothamNarrow-Medium"];
	// Do any additional setup after loading the view.
    
    UIGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)cameraView:(NGCameraView *)view faceFoundInFrame:(CGRect)frame {

    if(!CGRectEqualToRect(frame, CGRectZero)) {
        self.screensaverDate = [NSDate date];
    }
    
    BOOL contains = CGRectContainsRect(self.faceSquareView.frame, frame);
    if(contains) {
        [self longPressToLoad:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.screensaverDate = [NSDate date];
    [[NGCoreTimer coreTimer] registerListener:self];
    self.cameraView.faceCaptureEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NGCoreTimer coreTimer] unregisterListener:self];
    self.cameraView.faceCaptureEnabled = NO;
}

-(void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {
    
    @autoreleasepool {
        @synchronized(self.navigationController) {
            NSDate * date = [NSDate date];
            NSTimeInterval interval = [date secondsBySubtracting:self.screensaverDate];
            
            if(interval >= ScreenSaverNSTimeIntervalTimeout) {
                [[NGCoreTimer coreTimer] unregisterListener:self];
                [self.navigationController popViewControllerAnimated:NO];
            }
        }
    }
}

- (void)longPressToLoad:(id)someData {
    [self.cameraView takePicture:^(UIImage *capturedImage, NSError *error) {
        [self doSomethingWithImage:capturedImage];
        self.cameraView.faceCaptureEnabled = NO;
    }];
}


- (void)onTap:(id)tap {
#if TARGET_IPHONE_SIMULATOR
    [self doSomethingWithImage:nil];
#endif
    
    // reset date
    self.screensaverDate = [NSDate date];
}


- (void)doSomethingWithImage:(UIImage *)image {
    NGUserPanelController * controller = [NGUserPanelController new];
    controller.imageToShow = image;
    [self.navigationController pushViewController:controller animated:YES];
    [[NGCoreTimer coreTimer] unregisterListener:self];
}

-(void)dealloc {
    [[NGCoreTimer coreTimer] unregisterListener:self];
    self.cameraView.delegate = nil;
    self.cameraView.faceCaptureEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
