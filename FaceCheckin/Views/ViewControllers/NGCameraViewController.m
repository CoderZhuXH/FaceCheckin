//
//  NGCameraViewController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraViewController.h"
#import "UILabel+NGExtensions.h"
#import "NGCameraView.h"

#import "NGUserPanelController.h"

@interface NGCameraViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alignFaceLabel;
@property (weak, nonatomic) IBOutlet NGCameraView *cameraView;

- (void)longPressToLoad:(id)someData;

@end

@implementation NGCameraViewController

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
    
    UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 2.0f;
    
    [self.view addGestureRecognizer:recognizer];
    
    NSLog(@"viewDidLoad on object %@", self.description);
    [self.alignFaceLabel fitTextToWidth:self.alignFaceLabel.frame.size.width forFontName:@"GothamNarrow-Medium"];
	// Do any additional setup after loading the view.
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {

    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        [self longPressToLoad:nil];
    }
}

- (void)longPressToLoad:(id)someData {
    NSLog(@"longPressToLoad on object %@", self.description);
    
    [self.cameraView takePicture:^(UIImage *capturedImage, NSError *error) {
        [self doSomethingWithImage:capturedImage];
    }];
}

- (void)doSomethingWithImage:(UIImage *)image {
    
    NSLog(@"doSomethingWithImage on object %@", self.description);
    
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
