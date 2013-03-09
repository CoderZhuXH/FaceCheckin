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

#import "NGCloudObjectAPI.h"
#import "NGCheckinData.h"

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
    [formatter setDateFormat:@"EEE, MMM dd YYYY"];
    self.dateLabel.text = [[formatter stringFromDate:currentDate] uppercaseString];
    
    self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:74];
    self.dateLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:67];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NGCoreTimer coreTimer] registerListener:self];
    
    
    /*
    NSString * path = [[NSBundle mainBundle] pathForResource:@"TimeClockMock" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    id array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray * timeClockCloudObjects = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (NSDictionary * dict in array) {
        
        NGTimeClockCloudObject * obj = [[NGTimeClockCloudObject alloc] initWithDictionary:dict];
        
        NSAssert(obj.dateCheckingIn   , @"Should be somthing");
        NSAssert(obj.dateCheckingOut  , @"Should be somthing");
        NSAssert(obj.dayOfWeek        , @"Should be somthing");
        NSAssert(obj.hoursWorked > 0    , @"Should be positive and not %.2f", obj.hoursWorked);
        NSAssert(obj.dayOfWeek        , @"Has version");
        
        [timeClockCloudObjects addObject:obj];
    }
    
    NSDate * checkin = [[[NSDate date] dateByStrippingHours] dateByAddingHours:8];
    NSDate * checkOut = [[[NSDate date] dateByStrippingHours] dateByAddingHours:16];
    
    NGCheckinData * cData = [[NGCheckinData alloc] initWithCheckIn:checkin andCheckout:checkOut];
    
    NGTimeClockCloudObject * cloud = [timeClockCloudObjects objectAtIndex:0];
    
    [cloud mergeWithCheckinData:cData];
    
    NSDictionary * letsee = [cloud dictionaryRepresentation];
    NSLog(@"%@", [letsee description]);

    [cloud uploadData:^(NSError *error) {
        
    }];
     */
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
