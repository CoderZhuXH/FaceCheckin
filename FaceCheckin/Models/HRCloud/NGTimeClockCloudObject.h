//
//  NGTimeClockCloudObject.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/8/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCloudObjectAPI.h"

@class NGCheckinData;

@interface NGTimeClockCloudObject : NGCloudObject

+ (void)getCloudObjectWithCallback:(NGCloudObjectAPICallback)callback;

// real
#define jkClockCloudObjectTimeIn    @"Time_In_Txt"
#define jkClockCloudObjectTimeOut   @"Time_out_Txt"
#define jkClockCloudObjectDate      @"Date"

// calculated
#define jkClockCloudObjectDayOfWeek     @"Day_of_Week"
#define jkClockCloudObjectHours_Worked  @"Hours_Worked"

@property (nonatomic, strong) NSDate * dateCheckingIn;
@property (nonatomic, strong) NSDate * dateCheckingOut;

@property (nonatomic, readonly) CGFloat hoursWorked; // 2 decimals
@property (nonatomic, readonly) NSString * dayOfWeek;

- (BOOL)isReadyToSend;

- (void)uploadData:(void (^)(NSError * error))callback;
- (void)mergeWithCheckinData:(NGCheckinData *)checkinData;


@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSArray (NGCloudObjectExtensions)

- (NSArray *)cloudObjectsForEmployeeNumberFast:(NSInteger)employeeNumber;

@end