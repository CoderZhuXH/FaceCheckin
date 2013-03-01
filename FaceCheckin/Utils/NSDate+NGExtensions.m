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
    NSTimeInterval firstByte = ([self timeIntervalSince1970] - [other timeIntervalSince1970]);
    return (NSUInteger)ceil(firstByte);
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
