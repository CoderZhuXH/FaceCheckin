//
//  NGDailyReportCellObject.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyReportCellObject.h"
#import "NGDailyReportCell.h"

#import "NGDailyDataMock.h"
#import "NSDate+NGExtensions.h"
#import "NGCheckinData.h"

@implementation NGDailyReportCellObject

#pragma mark Data Mockups

+ (NSArray *)cellObjectsFromReportData:(NSArray *)reportData {
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:reportData.count];
    
    for (NGDailyDataMock * mocked in reportData) {
        NGDailyReportCellObject * obj = [[NGDailyReportCellObject alloc] initWithDailyReport:mocked];
        [arr addObject:obj];
    }
    return [NSArray arrayWithArray:arr];
}

+ (NSArray *)mockSomeData {
    
    NSMutableArray * arrayOfData = [NSMutableArray arrayWithCapacity:7];
    
    NSArray * array = [[NSDate date] entireWeekFromDate];
    
    
    for (NSDate * singleDate in array) {
        
        NSDate * workingDate = [[singleDate dateByStrippingHours] dateByAddingHours:8];
        NSUInteger numberOfCheckins = arc4random_uniform(3)+1;
        
        NSMutableArray * arrayOfCheckins = [NSMutableArray arrayWithCapacity:numberOfCheckins];
        
        for (uint k = 0; k < numberOfCheckins; k++) {
            
            CGFloat hours = 2 + arc4random_uniform(180)/60.0f;
            
            NSDate * date2 = [workingDate dateByAddingTimeInterval:HOURS(hours)];
            
            NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:workingDate andCheckout:date2];
            [arrayOfCheckins addObject:data];
            
            workingDate = [date2 dateByAddingTimeInterval:MINUTES(arc4random_uniform(30)+15)];
        }
        
        NGDailyDataMock * mockery = [[NGDailyDataMock alloc] initWithCheckins:arrayOfCheckins];

        [arrayOfData addObject:mockery];
    }
    
    return [NSArray arrayWithArray:arrayOfData];
}

#pragma -

- (id)initWithDailyReport:(id)dailyReportData {
    self = [super init];
    
    if (self) {
        _dailyReportData = dailyReportData;
    }
    
    return self;
}

- (Class)classForCellItem {
    return [NGDailyReportCell class];
}

@end
