//
//  NGCloudObjectAPI.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCloudObjectAPI.h"
#import "NGHRCloudApi.h"

@implementation NGCloudObject

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback {
    
    NGHRCloudApi * api = [NGHRCloudApi sharedApi];
    
    NSString * pathToGet =  [NSString stringWithFormat:@"/rest/CLOUD/%@", cloudObjectName];
    
    [api getPath:pathToGet parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Got response: %@", responseObject);
        
        NSAssert([responseObject isKindOfClass:[NSArray class]], @"responseObject must be of NSArray JSON and not %@", NSStringFromClass([responseObject class]));
        
        NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary * cloudObjectDatum in responseObject) {
            NGCloudObject * obj = [[NGCloudObject alloc] initWithDictionary:cloudObjectDatum];
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
        _objectId       = [dictionary objectForKey:@"Id"];
        _employeeNumber = [dictionary objectForKey:@"Employee_Number"];
        _employeeName   = [dictionary objectForKey:@"Employee_Name"];
        
        NSMutableDictionary * mutableMe = [dictionary mutableCopy];
        [mutableMe removeObjectsForKeys:@[@"Id",@"Employee_Number",@"Employee_Name"]];
        
        _cloudObject = [NSDictionary dictionaryWithDictionary:mutableMe];
        
        _fastEmployeeNumber = [_employeeNumber integerValue];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Object ID:%@, Employee Name:%@, Employee number:%d, Cloud Object:%@", self.objectId,self.employeeName,self.fastEmployeeNumber, self.cloudObject];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSArray (NGCloudObjectExtensions)

- (NSArray *)cloudObjectsForEmployeeNumberFast:(NSInteger)employeeNumber {
    
    NSMutableArray * results = [NSMutableArray array];
    
    for (NGCloudObject * base in self) {
        
        if(base.fastEmployeeNumber == employeeNumber) {
            [results addObject:base];
        }
    }
    
    return [NSArray arrayWithArray:results];
}

@end