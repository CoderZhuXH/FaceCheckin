//
//  NGEmployeeData.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/5/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

#define PROP_NRO @property (nonatomic, readonly)

@class NGEmployeeData;
@class NGEmployeePosition;

typedef void(^NGEmployeeDataCallback)(NGEmployeeData * data, NSError * error);

@interface NGEmployeeData : NGDomainObjectBase

+ (void)getEmployeeDataForEncryptedID:(NSString *)eid forCallback:(NGEmployeeDataCallback)callback;

+ (NSString *)encryptedIdForId:(NSString *)skyBiometryId;

PROP_NRO NSString * id;
PROP_NRO NSString * uri;
PROP_NRO BOOL isActive;
PROP_NRO NSString * firstName;
PROP_NRO NSString * lastName;
PROP_NRO NSString * email;
PROP_NRO NSNumber * employeeNumber;
PROP_NRO NSString * evaluationCycleDate;

PROP_NRO NSInteger fastEmployeeNumber;

PROP_NRO NGEmployeePosition * position;

@end

@interface NGEmployeePosition : NGDomainObjectBase

PROP_NRO NSString * code;
PROP_NRO NSString * title;
PROP_NRO NSString * positionId;
PROP_NRO NSString * uri;

@end
