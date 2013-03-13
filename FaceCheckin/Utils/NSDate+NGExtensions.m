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

- (NSComparisonResult)compareByDates:(NSDate *)other {
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [currentCalendar components: NSDayCalendarUnit
                                                      fromDate: self
                                                        toDate: other
                                                       options: 0];
    if(components.day == 0) {
        return NSOrderedSame;
    } else if (components.day < 0) {
        return NSOrderedDescending;
    } else {
        return NSOrderedAscending;
    }
    
    return 0;
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

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSDate *now = self;
    NSInteger daysToAdd = days;  // or 60 :-)
    
    // set up date components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:daysToAdd];
    
    // create a calendar
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *newDate2 = [gregorian dateByAddingComponents:components toDate:now options:0];
    
    return newDate2;
}

- (NSArray *)entireWeekFromDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [gregorian setLocale:locale];
    
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:self];
    NSInteger weekday = weekdayComponents.weekday;
    
    NSDate * firstDayOfWeek = [self dateByAddingDays:-weekday+2]; // first get it to zero and then add 2 days because monday is on index 2.
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:7];
    [array addObject:firstDayOfWeek];
    
    for (uint8_t i = 1; i < 7; i++) {
        [array addObject:[firstDayOfWeek dateByAddingDays:i]];
    }
    
    return [NSArray arrayWithArray:array];
}

- (CGFloat)pixelPerMinuteInTimeIntervalSinceDate:(NSDate *)date forPixels:(CGFloat)pixels {
    NSUInteger minutesDelta = [self secondsBySubtracting:date] / 60.0f;
    return pixels/minutesDelta; // pixels for minute
}

-(NSDate *)dateByAddingHours:(NSInteger)hours {
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
