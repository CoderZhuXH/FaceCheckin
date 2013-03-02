//
//  NSDate+NGExtensions.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NSDate+NGExtensions.h"

@interface NSDate (NGPrivate)

- (NSDateComponents *)gregorianComponentsWithCalendarReuse:(NSCalendar *__autoreleasing *)calendar;

@end

@implementation NSDate (NGExtensions)


- (NSDateComponents *)dateComponents {
    
    return [self gregorianComponentsWithCalendarReuse:nil];
}

- (NSDate *)dateByStrippingHours {
    
    NSCalendar * calendar = nil;
    NSDateComponents * components = [self gregorianComponentsWithCalendarReuse:&calendar];
    
    components.minute = 0;
    components.hour = 0;
    components.second = 0;
    
    NSDate * date = [calendar dateFromComponents:components];
    return date;
}

+ (NSDate *)dateFromComponentsGregorian:(NSDateComponents *)components {
    NSCalendar * internalCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [internalCalendar dateFromComponents:components];
}

- (NSInteger)secondsBySubtracting:(NSDate *)other {
    NSTimeInterval firstByte = [self timeIntervalSinceDate:other];
    return (NSUInteger)ceil(firstByte);
}

- (NSInteger)minutesBySubtracting:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger cEnum = NSMinuteCalendarUnit;

    NSDateComponents * components = [gregorian components:cEnum fromDate:date toDate:self options:0];
    return components.minute;
}

- (NSDate *)dateByAddingDays:(NSUInteger)days {
    NSDate *now = self;
    int daysToAdd = days;  // or 60 :-)
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:now options:0];
    NSLog(@"Clean: %@", newDate2);
    
    return newDate2;
}

- (CGFloat)pixelPerMinuteInTimeIntervalSinceDate:(NSDate *)date forPixels:(CGFloat)pixels {
    NSUInteger minutesDelta = [self secondsBySubtracting:date] / 60.0f;
    return pixels/minutesDelta; // pixels for minute
}

-(NSDate *)dateByAddingHours:(NSUInteger)hours {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = hours;
    
    return [gregorian dateByAddingComponents:components toDate:self options:0];
}


@end

@implementation NSDate (NGPrivate)

- (NSDateComponents *)gregorianComponentsWithCalendarReuse:(NSCalendar *__autoreleasing *)calendar {
    
    NSCalendar * internalCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger cEnum = NSYearCalendarUnit |  NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    if(calendar != nil) {
        *calendar = internalCalendar;
    }
    return [internalCalendar components:cEnum fromDate:self];
}

@end
