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
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToLoad:)];
    
    [longPress setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:longPress];
    
    [self.alignFaceLabel fitTextToWidth:self.alignFaceLabel.frame.size.width forFontName:@"GothamNarrow-Medium"];
	// Do any additional setup after loading the view.
}

- (void)longPressToLoad:(id)someData {
    NGUserPanelController * controller = [NGUserPanelController new];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
