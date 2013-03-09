//
//  NGCloudObjectAPI.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCloudObjectAPI.h"
#import "NGHRCloudApi.h"
#import "NGCheckinData.h"

#import "NSDate+NGExtensions.h"
#import "AFNetworking.h"

@implementation NGCloudObject

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback {
    
    NGHRCloudApi * api = [NGHRCloudApi sharedApi];
    
    NSString * pathToGet =  [NSString stringWithFormat:@"/rest/CLOUD/%@", cloudObjectName];
    
    [api getPath:pathToGet parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Got response: %@", responseObject);
        
        NSAssert([responseObject isKindOfClass:[NSArray class]], @"responseObject must be of NSArray JSON and not %@", NSStringFromClass([responseObject class]));
        
        NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary * cloudObjectDatum in responseObject) {
            NGCloudObject * obj = [[[self class] alloc] initWithDictionary:cloudObjectDatum];
            [resultArray addObject:obj];
        }
        
        callback([NSArray arrayWithArray:resultArray],nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
    }];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _objectId       = [dictionary objectForKey:jkCloudObjectId];
        _employeeNumber = [dictionary objectForKey:jkCloudObjectEmployeeNumber];
        _employeeName   = [dictionary objectForKey:jkCloudObjectEmployeeName];
        
        NSMutableDictionary * mutableMe = [dictionary mutableCopy];
        [mutableMe removeObjectsForKeys:@[jkCloudObjectId, jkCloudObjectEmployeeNumber, jkCloudObjectEmployeeName]];
        
        _cloudObject = [NSDictionary dictionaryWithDictionary:mutableMe];
        _fastEmployeeNumber = [_employeeNumber integerValue];
    }
    
    [self configureObject];
    return self;
}

- (void)configureObject {
    // using with inheritence
}

#pragma mark - Services and support

- (NGCloudObject *)cloudObjectWithEmployeeIdAndName {
    return [[[self class] alloc] initWithDictionary:@{jkCloudObjectEmployeeName: self.employeeName, jkCloudObjectEmployeeNumber: self.employeeNumber, jkCloudObjectId : [NSString string]}];
}

+ (NGCloudObject *)templateWithEmployeeId:(NSString *)empID andName:(NSString *)name {
    return [[[self class] alloc] initWithDictionary:@{jkCloudObjectEmployeeName: name, jkCloudObjectEmployeeNumber: empID ,jkCloudObjectId:[NSString string]}];
}


#pragma mark - TO JSON. First!

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:3 + self.cloudObject.count];
    
    [dict setObject:self.employeeName   forKey:jkCloudObjectEmployeeName    ];
    [dict setObject:self.employeeNumber forKey:jkCloudObjectEmployeeNumber  ];
    [dict setObject:self.objectId       forKey:jkCloudObjectId              ];

    // add other elements
    [dict addEntriesFromDictionary:self.cloudObject];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Object ID:%@, Employee Name:%@, Employee number:%d, Cloud Object:%@", self.objectId,self.employeeName,self.fastEmployeeNumber, self.cloudObject];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
