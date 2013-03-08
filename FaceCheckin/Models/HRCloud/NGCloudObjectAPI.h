//
//  NGCloudObjectAPI.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

typedef void(^NGCloudObjectAPICallback)(NSArray * cloudObjects, NSError * error);


#define jkCloudObjectId             @"Id"
#define jkCloudObjectEmployeeNumber @"Employee_Number"
#define jkCloudObjectEmployeeName   @"Employee_Name"

@interface NGCloudObject : NGDomainObjectBase

#pragma mark - Builders

+ (NGCloudObject *)templateWithEmployeeId:(NSInteger)id andName:(NSString *)name;
- (NGCloudObject *)cloudObjectWithEmployeeIdAndName;

#pragma mark - APIs

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback;

#pragma mark - Properties
//
@property (nonatomic, readonly) NSString        * employeeName;
@property (nonatomic, readonly) NSNumber        * employeeNumber;
// BONUS
@property (nonatomic, readonly) NSInteger       fastEmployeeNumber;
//

@property (nonatomic, readonly) NSString        * objectId;
@property (nonatomic, readonly) NSDictionary    * cloudObject;

@end


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

- (void)uploadData:(void (^)(NSError * error))callback;


@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSArray (NGCloudObjectExtensions)

- (NSArray *)cloudObjectsForEmployeeNumberFast:(NSInteger)employeeNumber;

@end