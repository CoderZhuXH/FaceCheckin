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

@implementation NGDailyReportCellObject


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
