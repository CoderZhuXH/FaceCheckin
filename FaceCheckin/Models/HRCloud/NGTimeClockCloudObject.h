//
//  NGTimeClockCloudObject.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/8/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCloudObjectAPI.h"

@class NGCheckinData;
@class NGEmployeeData;

@interface NGTimeClockCloudObject : NGCloudObject

+ (void)getCloudObjectWithCallback:(NGCloudObjectAPICallback)callback;
+ (void)getCloudObjectForEmployeeData:(NGEmployeeData *)employeeData withCallback:(NGCloudObjectAPICallback)callback;

// real
#define jkClockCloudObjectTimeIn    @"Time_In_Txt"
#define jkClockCloudObjectTimeOut   @"Time_out_Txt"
#define jkClockCloudObjectDate      @"Date"

// calculated
#define jkClockCloudObjectDayOfWeek     @"Day_of_Week"
#define jkClockCloudObjectHours_Worked  @"Hours_Worked"

#define jkTimeClockCloudObjectName      @"Time_Clock"

@property (nonatomic, strong) NSDate * dateCheckingIn;
@property (nonatomic, strong) NSDate * dateCheckingOut;

@property (nonatomic, readonly) CGFloat hoursWorked; // 2 decimals
@property (nonatomic, readonly) NSString * dayOfWeek;

- (void)mergeWithCheckinData:(NGCheckinData *)checkinData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSArray (NGCloudObjectExtensions)

- (NSArray *)cloudObjectsForEmployeeNumberFast:(NSInteger)employeeNumber;
- (NSArray *)cloudObjectsForThisWeek;

@end