//
//  NGCameraViewController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCameraViewController.h"
#import "UILabel+NGExtensions.h"

@interface NGCameraViewController ()

@property (weak, nonatomic) IBOutlet UILabel *alignFaceLabel;

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
    
    [self.alignFaceLabel fitTextToWidth:self.alignFaceLabel.frame.size.width forFontName:@"GothamNarrow-Medium"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
