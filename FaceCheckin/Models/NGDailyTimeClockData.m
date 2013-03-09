//
//  NGDailyDataMock.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyTimeClockData.h"

#import "NGCheckinData.h"
#import "NSDate+NGExtensions.h"

#import "NGCloudObjectAPI.h"
#import "NGTimeClockCloudObject.h"

@implementation NGDailyTimeClockData {
    // Private cached iVars
    CGFloat         _hours;
}


- (id)initBasic:(NSDate *)date
{
    self = [super init];
    if (self) {
        _dayInfo = [date dateByStrippingHours];
        _hours = -1;
        _checkins = [NSArray array];
    }
    return self;
}

- (id)initWithCheckins:(NSArray *)checkins {
    
    self = [super init];
    if (self) {
        
        for (id checkin in checkins) {
            if (![checkin isKindOfClass:[NGCheckinData class]]) [MMExceptionUtils raiseNotImplementedException:@"You are to use NGCheckinData here!"];
            
            if(_dayInfo == nil) {
                _dayInfo = [[checkin checkIn] dateByStrippingHours];
            }
        }
        
        _checkins = checkins;
        _hours = -1;
    }
    
    return self;
}

- (BOOL)insertCheckinData:(NGCheckinData *)data
{
    NSDate * date = [data.checkIn dateByStrippingHours];
    
    if([date compare:_dayInfo] != NSOrderedSame)
        return NO;
    
    _checkins = [self.checkins arrayByAddingObject:data];
    _hours = -1; // resetting hours
    return YES;
}

+ (NSArray *)getPlaceholders {
    NSArray * array = [[NSDate date] entireWeekFromDate];
    
    NSMutableArray * returnData = [NSMutableArray arrayWithCapacity:7];
    
    for (NSDate * date in array) {
        NGDailyTimeClockData * dailyData = [[NGDailyTimeClockData alloc] initBasic:date];
        [returnData addObject:dailyData];
    }
    
    return [NSArray arrayWithArray:returnData];
}

+ (NSArray *)createDailyClockDataFromCloudObjects:(NSArray *)cloudObjects {
    
    NSMutableDictionary * checkinsPerDate = [NSMutableDictionary dictionary];
    
    for (NGTimeClockCloudObject * tcco in cloudObjects) {
        
        NSDate * dateKey = [tcco.dateCheckingIn dateByStrippingHours];
        
        NSMutableArray * lmnts = [checkinsPerDate objectForKey:dateKey];
        if (!lmnts) {
            lmnts = [NSMutableArray array];
        }
        
        NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:tcco.dateCheckingIn andCheckout:tcco.dateCheckingOut];
        [lmnts addObject:data];
        
        NSArray *sortedArray;
        sortedArray = [lmnts sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(NGCheckinData*)a checkIn];
            NSDate *second = [(NGCheckinData*)b checkIn];
            return [first compare:second];
        }];
        
        [checkinsPerDate setObject:[sortedArray mutableCopy] forKey:dateKey];
        
    }
    
    NSArray * sorted = [[checkinsPerDate allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedValues = [NSMutableArray arrayWithCapacity:sorted.count];
    
    for (NSDate * arr in sorted) {
        NGDailyTimeClockData * daily = [[NGDailyTimeClockData alloc] initWithCheckins:[checkinsPerDate objectForKey:arr]];
        [sortedValues addObject:daily];
    }
    
    return sortedValues;
}

#pragma mark - Accessors

- (NSDate *)objectDate {
    return _dayInfo;
    
}

- (CGFloat)hours {
    
    if(_hours == -1) {
        
        NSUInteger seconds = 0;
        for (NGCheckinData * checkinData in self.checkins) {
            seconds += ([checkinData.checkOut secondsBySubtracting:checkinData.checkIn]);
        }
        
        _hours = (CGFloat)seconds / 3600.0f;
    }
    
    return _hours;
}

@end
