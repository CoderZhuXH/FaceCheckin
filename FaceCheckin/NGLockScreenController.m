//
//  NGViewController.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGLockScreenController.h"
#import "NSDate+NGExtensions.h"
#import "UILabel+NGExtensions.h"
#import "NGCameraViewController.h"

@interface NGLockScreenController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)onTap:(id)sender;

@end

@implementation NGLockScreenController

- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {

    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h:mm a"];
    
    NSDate * currentDate = [NSDate date];
    
    self.timeLabel.text = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"MMM d YYYY"];
    self.dateLabel.text = [[formatter stringFromDate:currentDate] uppercaseString];
    
    [self.timeLabel fitTextToWidth:self.timeLabel.frame.size.width forFontName:@"GothamNarrow-Bold"];
    [self.dateLabel fitTextToWidth:self.timeLabel.frame.size.width forFontName:@"GothamNarrow-Medium"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NGCoreTimer coreTimer] registerListener:self];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    
    NGCameraViewController * vc = [[NGCameraViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
