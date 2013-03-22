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
typedef void(^NGCloudObjectAPISendDataCallback)(id responseJson, NSError * error);

@class NGEmployeeData;
@class NGCloudEmployeeData;

#define jkCloudObjectId                 @"Id"
#define jkCloudObjectEmployeeData       @"Employee"

#define NGCloudObjectCannotSendError    -1337
#define NGCloudObjectCannotSendDesc     @"Cannot send the object because it's not ready to send!"

@interface NGCloudObject : NGDomainObjectBase {
    @protected
    NSString * _secretCloudObjectName;
}

#pragma mark - Builders

- (NGCloudObject *)cloudObjectWithEmployeeIdAndName;
+ (NGCloudObject *)templateWithEmployee:(NGEmployeeData *)employee;

#pragma mark - APIs

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback;

#pragma mark - Properties

@property (nonatomic, readonly) NSString        * objectId;
@property (nonatomic, readonly) NGCloudEmployeeData * employeeData;

// BONUS
@property (nonatomic, readonly) NSInteger       fastEmployeeNumber;
@property (nonatomic, readonly) NSDictionary    * cloudObject;

- (void)configureObject;
- (BOOL)isReadyToSend;

/// Upload data in the object. Will check
- (void)uploadDataForCloudObject:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPISendDataCallback)callback;

/// Legacy method to upload data...
- (void)uploadData:(NGCloudObjectAPISendDataCallback)callback;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

#define jkCloudEmployeeDataId       @"Id"
#define jkCloudEmployeeDataName     @"Name"
#define jkCloudEmployeeDataNumber   @"EmployeeNumber"

@interface NGCloudEmployeeData : NGDomainObjectBase

@property (nonatomic, readonly) NSString * employeeId;
@property (nonatomic, readonly) NSString * employeeNumber;

@property (nonatomic, readonly) NSString * nameAndSurname;

+ (NGCloudEmployeeData *)cloudEmployeeDataFromEmployee:(NGEmployeeData *)empData;

@end