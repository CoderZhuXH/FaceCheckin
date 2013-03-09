//
//  NGHourlyStatus.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGHourlyStatus.h"
#import "NSDate+NGExtensions.h"
#import "UILabel+NGExtensions.h"
#import "NGCheckinData.h"
#import "NGDailyTimeClockData.h"
#import "NGCheckinInterval.h"

#import <QuartzCore/QuartzCore.h>

@interface NGHourlyStatus ()

////////////////////////////// -> Mutable Labels

////////////////////////////// -> Views

@property (weak, nonatomic) IBOutlet    UIView              * checkinSlider;
@property (strong, nonatomic)           NGCheckinInterval   * checkinInterval;

////////////////////////////// -> Business Logic

@property (nonatomic, strong) NSArray           * checkins;
@property (nonatomic, strong) NGCheckinFactory  * checkinFactory;
@property (nonatomic, assign) CGFloat           pixelsPerMinute;

@property (nonatomic, strong) NSDate            * upperBound;
@property (nonatomic, strong) NSDate            * lowerBound;

////////////////////////////// -> Instance methods of Interest

- (void)clockInWithForcedDate:(NSDate *)date;
- (void)clockOutWithForcedDate:(NSDate *)date;

- (void)drawCursorForDate:(NSDate *)date;

@end

@implementation NGHourlyStatus {
    NSDate * _currentStart;
    NSDate * _currentEnd;
    
    CGFloat deltaPixels;
}

- (void)customInit {
    
//    self.dateLabel.font = self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:24];
    
    self.checkinSlider.clipsToBounds = YES;
    
    self.checkins = [NSArray array];
    self.checkinFactory = [NGCheckinFactory new];
    self.checkinFactory.isSimulating = YES;
    
    NSDate * date = [NSDate date];
    date = [date dateByStrippingHours];
    /*
    CALayer * layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithRed:213.0/255 green:210.0/255 blue:198.0/255 alpha:1.0f].CGColor;
    layer.frame = CGRectMake(0, 96, self.nibView.bounds.size.width, 32);
    [self.layer addSublayer:layer];
    
    */

    CALayer * otherLayer = [CALayer layer];
    otherLayer.backgroundColor = [UIColor colorWithRed:245.0f/255 green:242.0f/255 blue:229.0f/255 alpha:1.0f].CGColor;
    otherLayer.frame = CGRectMake(0, self.bounds.size.height-80.0f, self.bounds.size.width, 2);
    [self.layer addSublayer:otherLayer];
     
    self.lowerBound= [date dateByAddingHours:6.0];
    self.upperBound  = [self.lowerBound dateByAddingHours:15.0];
}

/*
- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData {
    NSDateFormatter * formatter = [NSDateFormatter new];
    
    [formatter setDateFormat:@"MMM d, YYYY"];
    self.dateLabel.text = [formatter stringFromDate:date].uppercaseString;
    
    [formatter setDateFormat:@"h:mm a"];
    self.timeLabel.text = [formatter stringFromDate:date].uppercaseString;
}
*/

- (void)loadCheckinData:(NGDailyTimeClockData *)data {
    
    for (NGCheckinData * datum in data.checkins) {
        [self clockInWithForcedDate:datum.checkIn];
        
        if(datum.checkOut != nil) {
            [self clockOutWithForcedDate:datum.checkOut];
        } else {
            [self drawCursorForDate:[NSDate date]];
        }
    }
}

- (NSDate *)clockIn {
    NSDate * clockinDate = [self.checkinFactory clockIn];
    [self clockInWithForcedDate:clockinDate];
    
    return clockinDate;
}

- (NSDate *)clockOut {
    NSDate * clockoutDate = [self.checkinFactory clockOut];
    [self clockOutWithForcedDate:[self.checkinFactory clockOut]];

    return clockoutDate;
}

- (void)clockInWithForcedDate:(NSDate *)date {
    _currentStart = date;
    [self.checkinFactory manualClockIn:date];
    [self clockInActual];
}

- (void)clockOutWithForcedDate:(NSDate *)date {
    _currentEnd = date;
    [self.checkinFactory manualClockOut:date];
    [self clockOutActual];
}

- (void)clockInActual{
    
    if(self.sessionInProgress) {
        return;
    }
    
    self.checkinInterval = [[NGCheckinInterval alloc] init];
    
    [self.checkinInterval setClockInDate:_currentStart];
    
    if(self.checkins.count == 0) {
        self.pixelsPerMinute = [self.upperBound pixelPerMinuteInTimeIntervalSinceDate:self.lowerBound forPixels:self.checkinSlider.frame.size.width];
        
        CGFloat delta = [_currentStart minutesBySubtracting:self.lowerBound];
        deltaPixels = delta * self.pixelsPerMinute;
        [self.checkinInterval setPositionOnSlider:deltaPixels];
        
    } else {
        CGFloat minutesSirMinutes =  [_currentStart secondsBySubtracting:self.checkinFactory.startDate] / 60.0f;
        CGFloat xPos = self.pixelsPerMinute * minutesSirMinutes;
        [self.checkinInterval setPositionOnSlider:deltaPixels + xPos];
        NSLog(@"The break took: %f minutes!", (CGFloat)[_currentStart secondsBySubtracting:_currentEnd] / 60);
    }
    
    [self.checkinSlider addSubview:self.checkinInterval];
    _sessionInProgress = YES;
}

- (void)clockOutActual {
    
    if(!self.sessionInProgress) {
        return;
    }
    
    NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:_currentStart andCheckout:_currentEnd];
    self.checkins = [self.checkins arrayByAddingObject:data];
    
    NSLog(@"Hours checked in:%.2f", data.hours);
    [self.checkinInterval setClockOutDate:_currentEnd pixelsPerMinute:self.pixelsPerMinute];
    
    _sessionInProgress = NO;
}

- (void)drawCursorForDate:(NSDate *)date {
    
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

- (void)manualClockIn:(NSDate *)date {
    
    if(self.startDate == nil) {
        _startDate = date;
        self.start = _startDate;
    } else {
        self.start = date;
    }
}


- (void)manualClockOut:(NSDate *)date {
    self.end = date;
}

- (NSDate *)clockIn {

    if(!self.isSimulating) {
        return [NSDate date];
    }
    
    if(self.startDate == nil) {
        _startDate = [[[NSDate date] dateByStrippingHours] dateByAddingTimeInterval:HOURS(8)];
        self.start = self.startDate;
    } else {
        CGFloat hours = 0.33f + (CGFloat)arc4random_uniform(45)/60;
        self.start = [self.end dateByAddingTimeInterval:HOURS(hours)];
    }
    
    return self.start;
}

- (NSDate *)clockOut {
    
    if(!self.isSimulating) {
        return [NSDate date];
    }
    
    CGFloat hours = (CGFloat)arc4random_uniform(120)/60;
    self.end = [self.start dateByAddingTimeInterval:HOURS(2+hours)];

    return self.end;
}

@end
