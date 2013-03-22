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
#import "NGLoginController.h"

#import "NGCloudObjectAPI.h"
#import "NGTimeClockCloudObject.h"
#import "NGCheckinData.h"

@interface NGLockScreenController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)onTap:(id)sender;
- (IBAction)onboardButtonPressed:(id)sender;

@end

@implementation NGLockScreenController

- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {

    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h:mm a"];
    
    NSDate * currentDate = [NSDate date];
    
    self.timeLabel.text = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"EEE, MMM dd YYYY"];
    self.dateLabel.text = [[formatter stringFromDate:currentDate] uppercaseString];
    
    self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:74];
    self.dateLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:67];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NGCoreTimer coreTimer] registerListener:self];
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

- (IBAction)onboardButtonPressed:(id)sender {
    NGLoginController * lc = [[NGLoginController alloc] initWithLoginControllerMode:NGLoginControllerModeOnboard];
    [self.navigationController pushViewController:lc animated:NO];
}
@end
