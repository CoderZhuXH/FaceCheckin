//
//  NGDailyDataMock.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyDataMock.h"

#import "NGCheckinData.h"
#import "NSDate+NGExtensions.h"

@implementation NGDailyDataMock {
    // Private cached iVars
    
    NSDate *        _dayInfo;
    NSUInteger      _hours;
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
        _hours = NAN;
    }
    
    return self;
}

#pragma mark - Accessors

- (NSDate *)objectDate {
    return _dayInfo;
    
}

- (CGFloat)hours {
    
    if(_hours == NAN) {
        
        NSUInteger seconds = 0;
        for (NGCheckinData * checkinData in self.checkins) {
            seconds += ([checkinData.checkOut secondsBySubtracting:checkinData.checkIn]);
        }
        
        _hours = (CGFloat)seconds / 60;
    }
    
    return _hours;
}

@end
