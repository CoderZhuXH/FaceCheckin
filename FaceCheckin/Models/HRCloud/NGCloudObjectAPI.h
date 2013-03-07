//
//  NGCloudObjectAPI.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

typedef void(^NGCloudObjectAPICallback)(NSArray * cloudObjects, NSError * error);

@interface NGCloudObject : NGDomainObjectBase

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback;

@property (nonatomic, readonly) NSString * objectId;
@property (nonatomic, readonly) NSNumber * employeeNumber;
@property (nonatomic, readonly) NSString * employeeName;

@property (nonatomic, readonly) NSDictionary * cloudObject;


// BONUS
@property (nonatomic, readonly) NSInteger fastEmployeeNumber;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSArray (NGCloudObjectExtensions)

- (NSArray *)cloudObjectsForEmployeeNumberFast:(NSInteger)employeeNumber;

@end