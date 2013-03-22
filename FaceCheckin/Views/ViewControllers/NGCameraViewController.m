//
//  NGCameraViewController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraViewController.h"
#import "UILabel+NGExtensions.h"

#import "NGUserPanelController.h"

@interface NGCameraViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alignFaceLabel;
@property (weak, nonatomic) IBOutlet NGCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *faceSquareView;

@property (strong, nonatomic) NSTimer * capturingIn;

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
    
#if TARGET_IPHONE_SIMULATOR
    UIGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:recognizer];
#endif
}

- (void)cameraView:(NGCameraView *)view faceFoundInFrame:(CGRect)frame {
   
    return;
    
    BOOL contains = CGRectContainsRect(self.faceSquareView.frame, frame);
    
    if(contains) {
        [self longPressToLoad:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.cameraView.faceCaptureEnabled = YES;
    });
}

- (void)longPressToLoad:(id)someData {
    [self.cameraView takePicture:^(UIImage *capturedImage, NSError *error) {
        [self doSomethingWithImage:capturedImage];
        self.cameraView.faceCaptureEnabled = NO;
    }];
}

#if TARGET_IPHONE_SIMULATOR
- (void)onTap:(id)tap {
    [self doSomethingWithImage:nil];
}
#endif

- (void)doSomethingWithImage:(UIImage *)image {
    NGUserPanelController * controller = [NGUserPanelController new];
    controller.imageToShow = image;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
