//
//  NGHourlyStatus.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGHourlyStatus.h"
#import "NSDate+NGExtensions.h"
#import "NGCheckinData.h"

#import <QuartzCore/QuartzCore.h>

@interface NGHourlyStatus ()
////////////////////////////// -> Mutable Labels

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

////////////////////////////// -> Views

@property (weak, nonatomic) IBOutlet UIView *checkinSlider;

////////////////////////////// -> Business Logic

@property (nonatomic, strong) NSArray           * checkins;
@property (nonatomic, strong) NGCheckinFactory  * checkinFactory;

////////////////////////////// -> Instance methods of Interest

- (CALayer *)buildCheckpoint;
- (CGFloat)minutesPerPixel;

@end

#define CheckpointRectAt(x,y) CGRectMake(x, y, 8.0f, 64.0f)


@implementation NGHourlyStatus {
    NSDate * _currentStart;
    NSDate * _currentEnd;
    
    CGFloat pixelsPerMinute;
}

- (void)customInit {
    
    [[NGCoreTimer coreTimer] registerListener:self];
    
    self.dateLabel.font = self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:24];
    self.checkinSlider.layer.borderWidth = 2;
    self.checkinSlider.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.checkins = [NSArray array];
    self.checkinFactory = [NGCheckinFactory new];
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
    
    CALayer * checkPointAt = [self buildCheckpoint];
    
    _currentStart = [self.checkinFactory clockIn];
    
    if(self.checkins.count == 0) {
        checkPointAt.frame = CheckpointRectAt(0, 0);
        pixelsPerMinute = 1.0f/[self minutesPerPixel];
    } else {
        CGFloat xPos = pixelsPerMinute * [_currentStart secondsBySubtracting:self.checkinFactory.startDate] / 60;
        checkPointAt.frame = CheckpointRectAt(xPos, 0);
    }
    
    [self.checkinSlider.layer addSublayer:checkPointAt];
    _sessionInProgress = YES;
}

- (CGFloat)minutesPerPixel {
    CGFloat pixelWidth = self.checkinSlider.bounds.size.width;
    
    
    NSDate * stripped = [_currentStart dateByStrippingHours];
    NSDateComponents * components = [stripped dateComponents];
    components.day++;
    NSDate * midnight = [NSDate dateFromComponentsGregorian:components];
    
    CGFloat deltaMinutes = (CGFloat)[midnight secondsBySubtracting:_currentStart] / 60;
    CGFloat minutesPerPixel = deltaMinutes / pixelWidth;
    
    return minutesPerPixel;
}

- (void)clockOut {
    
    if(!self.sessionInProgress) {
        return;
    }
    
    _currentEnd = [self.checkinFactory clockOut];
    
    NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:_currentStart andCheckout:_currentEnd];
    self.checkins = [self.checkins arrayByAddingObject:data];
    
    NSLog(@"Hours checked in:%.2f", data.hours);
    
    CALayer * buildCheckpoint = [self buildCheckpoint];
    
    
    CGFloat position = pixelsPerMinute * [_currentEnd secondsBySubtracting:self.checkinFactory.startDate]/60;
    
    buildCheckpoint.frame = CheckpointRectAt(position, 0);
    [self.checkinSlider.layer addSublayer:buildCheckpoint];

    _sessionInProgress = NO;
}

- (CALayer *)buildCheckpoint {
    CALayer * checkPointAt = [CALayer layer];
    checkPointAt.backgroundColor = [UIColor darkGrayColor].CGColor;
    return checkPointAt;
}

- (NSArray *)checkinData {
    return [NSArray array];
}

- (void)dealloc {
    [[NGCoreTimer coreTimer] unregisterListener:self];
}

@end

@interface NGCheckinFactory ()

@property (nonatomic, strong) NSDate * start;
@property (nonatomic, strong) NSDate * end;

@end

@implementation NGCheckinFactory


- (NSDate *)clockIn {
    
    if(self.startDate == nil) {
        _startDate = [[[NSDate date] dateByStrippingHours] dateByAddingTimeInterval:HOURS(8)];
        self.start = self.startDate;
    } else {
        CGFloat hours = (CGFloat)arc4random_uniform(45)/60+0.33;
        self.start = [self.end dateByAddingTimeInterval:HOURS(hours)];
    }
    
    return self.start;
}

- (NSDate *)clockOut {
    
    CGFloat hours = (CGFloat)arc4random_uniform(120)/60;
    self.end = [self.start dateByAddingTimeInterval:HOURS(2+hours)];

    return self.end;
}

@end
