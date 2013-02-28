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


#define HOURS(x) (3600 * (x))
#define MINUTES(x) (60 * (x))

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
    
    NSDate * date = [[NSDate date] dateByStrippingHours];
    
    for(uint i = 1;i <= 7;i++) {
        
        NSUInteger numberOfCheckins = arc4random_uniform(3)+1;
        NSMutableArray * arrayOfCheckins = [NSMutableArray arrayWithCapacity:numberOfCheckins];
        
        date = [date dateByAddingTimeInterval:HOURS(8)];
        
        for (uint k = 0; k < numberOfCheckins; k++) {
        
            
            NSDate * date2 = [date dateByAddingTimeInterval:HOURS(arc4random_uniform(2)+3)];
            
            NGCheckinData * data = [[NGCheckinData alloc] initWithCheckIn:date andCheckout:date2];
            [arrayOfCheckins addObject:data];
            
            date = [date2 dateByAddingTimeInterval:MINUTES(arc4random_uniform(30)+15)];
        }
        
        date = [[[NSDate date] dateByAddingTimeInterval:i*HOURS(24)] dateByStrippingHours];
        
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
