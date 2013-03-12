//
//  NGDailyDataMock.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NGCheckinData;

@interface NGDailyTimeClockData : NSObject

- (id)initBasic:(NSDate *)date;
- (id)initWithCheckins:(NSArray *)checkins;

+ (NSArray *)createDailyClockDataFromCloudObjects:(NSArray *)cloudObjects;
+ (NSArray *)getPlaceholders;

@property (nonatomic, readonly) NSArray * checkins;
@property (nonatomic, readonly) NSDate * dayInfo;

- (NSDate *)objectDate;
- (CGFloat)hours;

- (BOOL)insertCheckinData:(NGCheckinData *)data;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSArray (NGDailyTimeClockDataExt)

- (CGFloat)totalHoursFromNGDailyTimeClockDataArray;

@end