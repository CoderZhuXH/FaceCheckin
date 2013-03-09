//
//  NGCloudObjectAPI.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"
#import "NGHRCloudApi.h"

typedef void(^NGCloudObjectAPICallback)(NSArray * cloudObjects, NSError * error);


#define jkCloudObjectId             @"Id"
#define jkCloudObjectEmployeeNumber @"Employee_Number"
#define jkCloudObjectEmployeeName   @"Employee_Name"

@interface NGCloudObject : NGDomainObjectBase

#pragma mark - Builders

+ (NGCloudObject *)templateWithEmployeeId:(NSString *)empID andName:(NSString *)name;
- (NGCloudObject *)cloudObjectWithEmployeeIdAndName;

#pragma mark - APIs

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback;

#pragma mark - Properties
//
@property (nonatomic, readonly) NSString        * employeeName;
@property (nonatomic, readonly) NSString        * employeeNumber;
// BONUS
@property (nonatomic, readonly) NSInteger       fastEmployeeNumber;
//

@property (nonatomic, readonly) NSString        * objectId;
@property (nonatomic, readonly) NSDictionary    * cloudObject;

- (void)configureObject;

@end