//
//  NGHourlyStatus.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGHourlyStatus.h"
#import <QuartzCore/QuartzCore.h>

@interface NGHourlyStatus ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIView *checkinSlider;

@end

@implementation NGHourlyStatus


- (void)customInit {
    
    [[NGCoreTimer coreTimer] registerListener:self];
    
    self.dateLabel.font = self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:24];
    self.checkinSlider.layer.borderWidth = 2;
    self.checkinSlider.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {
    NSDateFormatter * formatter = [NSDateFormatter new];
    NSDate * date = [NSDate date];
    
    [formatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [formatter stringFromDate:date].uppercaseString;
    
    [formatter setDateFormat:@"h:mm a"];
    self.timeLabel.text = [formatter stringFromDate:date].uppercaseString;
}

- (void)clockIn {
    
    if(self.sessionInProgress) {
        return;
    }
    
    _sessionInProgress = YES;
}

- (void)clockOut {
    
    if(!self.sessionInProgress) {
        return;
    }
    
    _sessionInProgress = NO;
    
}

- (NSArray *)checkinData {
    return [NSArray array];
}

- (void)dealloc {
    [[NGCoreTimer coreTimer] unregisterListener:self];
}

@end
