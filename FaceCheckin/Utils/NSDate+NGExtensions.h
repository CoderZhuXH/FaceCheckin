//
//  NSDate+NGExtensions.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HOURS(x) (3600 * (x))
#define MINUTES(x) (60 * (x))
#define DAYS(x) (24*(x)*HOURS(1))

@interface NSDate (NGExtensions)

- (NSDateComponents *)dateComponents;

- (NSDate *)dateByStrippingHours;
+ (NSDate *)dateFromComponentsGregorian:(NSDateComponents *)components;

- (NSInteger)secondsBySubtracting:(NSDate *)other;
- (NSInteger)minutesBySubtracting:(NSDate *)date;

- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;

- (CGFloat)pixelPerMinuteInTimeIntervalSinceDate:(NSDate *)date forPixels:(CGFloat)pixels;

- (NSArray *)entireWeekFromDate;

#define DATE_GT_OR_EQUAL(x,y) ([x compare:y] == NSOrderedDescending || [x compare:y] == NSOrderedSame)
#define DATE_LT_OR_EQUAL(x,y) ([x compare:y] == NSOrderedAscending || [x compare:y] == NSOrderedSame)

@end
