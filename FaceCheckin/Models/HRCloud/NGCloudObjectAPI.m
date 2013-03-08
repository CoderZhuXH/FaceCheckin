//
//  NGCloudObjectAPI.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCloudObjectAPI.h"
#import "NGHRCloudApi.h"

#import "NSDate+NGExtensions.h"

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
        _objectId       = [dictionary objectForKey:jkCloudObjectId];
        _employeeNumber = [dictionary objectForKey:jkCloudObjectEmployeeNumber];
        _employeeName   = [dictionary objectForKey:jkCloudObjectEmployeeName];
        
        NSMutableDictionary * mutableMe = [dictionary mutableCopy];
        [mutableMe removeObjectsForKeys:@[jkCloudObjectId, jkCloudObjectEmployeeNumber, jkCloudObjectEmployeeName]];
        
        _cloudObject = [NSDictionary dictionaryWithDictionary:mutableMe];
        
        _fastEmployeeNumber = [_employeeNumber integerValue];
    }
    return self;
}

#pragma mark - Services and support

- (NGCloudObject *)cloudObjectWithEmployeeIdAndName {
    return [[NGCloudObject alloc] initWithDictionary:@{jkCloudObjectEmployeeName: self.employeeName, jkCloudObjectEmployeeNumber: self.employeeNumber}];
}

+ (NGCloudObject *)templateWithEmployeeId:(NSInteger)empID andName:(NSString *)name {
    return [[NGCloudObject alloc] initWithDictionary:@{jkCloudObjectEmployeeName: name, jkCloudObjectEmployeeNumber: [NSNumber numberWithInteger:empID]}];
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

@implementation NGTimeClockCloudObject

+ (void)getCloudObjectWithCallback:(NGCloudObjectAPICallback)callback {
    
    [NGTimeClockCloudObject getCloudObjects:@"Time_Clock" withCallback:^(NSArray *cloudObjects, NSError *error) {
        if(!error) {
            
            NSMutableArray * returnArray = [NSMutableArray arrayWithCapacity:cloudObjects.count];
            
            for (NGCloudObject * cloudObj in cloudObjects) {
                
                NSDictionary * dict = [cloudObj dictionaryRepresentation];
                NGTimeClockCloudObject * obj = [[NGTimeClockCloudObject alloc] initWithDictionary:dict];
                [returnArray addObject:obj];
                
            }
            
            callback([NSArray arrayWithArray:returnArray], nil);
        } else {
            callback(nil, error);
        }
        
    }];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"M/d/yyyy"];
        
        NSDate * father = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectDate]];
        
        [formatter setDateFormat:@"HH:mm"];
        
        NSDate * timeIn     = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectTimeIn]];
        NSDate * timeOut    = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectTimeOut]];
        
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents * componentsIn     = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeIn];
        NSDateComponents * componentsOut    = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeOut];
        
        timeIn  = [calendar dateByAddingComponents:componentsIn toDate:father options:0];
        timeOut = [calendar dateByAddingComponents:componentsOut toDate:father options:0];
        
        _dateCheckingIn = timeIn;
        _dateCheckingOut = timeOut;
        
        [formatter setDateFormat:@"EEE"];
        _dayOfWeek = [formatter stringFromDate:father];
        
        /*
        NSAssert(_dateCheckingOut   != nil, @"");
        NSAssert(_dateCheckingIn    != nil, @"");
        NSAssert([_dateCheckingOut compare:_dateCheckingIn] == NSOrderedDescending,@"");
         */
        
        _hoursWorked = [_dateCheckingOut minutesBySubtracting:_dateCheckingIn];
        
    }
    
    return self;
}


- (void)uploadData:(void (^)(NSError *))callback {
    callback(nil);
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