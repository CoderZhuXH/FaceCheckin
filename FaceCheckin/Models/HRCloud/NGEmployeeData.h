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

typedef void(^NGEmployeeDataCallback)(NGEmployeeData * data, NSError * error);

@interface NGEmployeeData : NGDomainObjectBase

+(void)getEmployeeDataForEncryptedID:(NSString *)eid forCallback:(NGEmployeeDataCallback)callback;

PROP_NRO NSString * id;
PROP_NRO NSString * uri;
PROP_NRO BOOL isActive;
PROP_NRO NSString * firstName;
PROP_NRO NSString * lastName;
PROP_NRO NSString * email;
PROP_NRO NSString * employeeNumber;

@end
