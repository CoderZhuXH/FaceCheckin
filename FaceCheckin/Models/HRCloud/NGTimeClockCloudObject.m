//
//  NGTimeClockCloudObject.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/8/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGTimeClockCloudObject.h"
#import "NGCheckinData.h"

#import "AFNetworking.h"

#import "NSDate+NGExtensions.h"
#import "NGEmployeeData.h"

#define DateFormatV1Point0 @"M/d/yyyy"
#define DateFormatV1Point5 @"M/d/yyyy HH:mm:ss a"

// make sure you are using a correct date format
#define CurrentDateFormat DateFormatV1Point0

@implementation NGTimeClockCloudObject

+ (void)getCloudObjectWithCallback:(NGCloudObjectAPICallback)callback {
    
    [NGTimeClockCloudObject getCloudObjects:@"Time_Clock" withCallback:^(NSArray *cloudObjects, NSError *error) {
        if(!error) {
            callback(cloudObjects, nil);
        } else {
            callback(nil, error);
        }
        
    }];
}

+ (void)getCloudObjectForEmployeeData:(NGEmployeeData *)employeeData withCallback:(NGCloudObjectAPICallback)callback {
    
    [[self class] getCloudObjectWithCallback:^(NSArray *cloudObjects, NSError *error) {
        
        if (error) {
            callback(nil, error);
            return;
        }
        
        NSMutableArray * cloudObjectForEmployeeId = [NSMutableArray arrayWithCapacity:cloudObjects.count];
        
        for (NGTimeClockCloudObject * timeClockCloudObject in cloudObjects) {
            if(timeClockCloudObject.fastEmployeeNumber == employeeData.fastEmployeeNumber) {
                timeClockCloudObject.employeeId = employeeData.employeeId;
                [cloudObjectForEmployeeId addObject:timeClockCloudObject];
            }
        }
        
        callback([NSArray arrayWithArray:cloudObjectForEmployeeId], nil);
    }];
}

- (BOOL)isReadyToSend {
    return (self.dateCheckingIn != nil) && (self.dateCheckingOut != nil);
}

- (void)configureObject {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:CurrentDateFormat]; // something happened here
    
    NSDate * father = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectDate]];
    
    if(father) {
        
        [formatter setDateFormat:@"EEE"];
        _dayOfWeek = [formatter stringFromDate:father];
        
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [formatter setDateFormat:@"HH:mm"];
        
        NSDate * timeIn     = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectTimeIn]];
        
        if (timeIn) {
            NSDateComponents * componentsIn     = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeIn];
            timeIn  = [calendar dateByAddingComponents:componentsIn toDate:father options:0];
            _dateCheckingIn = timeIn;
        }
        
        NSDate * timeOut    = [formatter dateFromString:[self.cloudObject objectForKey:jkClockCloudObjectTimeOut]];
        
        if (timeOut) {
            NSDateComponents * componentsOut    = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:timeOut];
            timeOut = [calendar dateByAddingComponents:componentsOut toDate:father options:0];
            _dateCheckingOut = timeOut;
            _hoursWorked = [_dateCheckingOut minutesBySubtracting:_dateCheckingIn] / 60.0f;
        }
    }
}

- (void)mergeWithCheckinData:(NGCheckinData *)checkinData {
    
    _dateCheckingIn     = checkinData.checkIn;
    _dateCheckingOut    = checkinData.checkOut;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE"];
    
    _dayOfWeek = [formatter stringFromDate:_dateCheckingIn];
    _hoursWorked = [_dateCheckingOut minutesBySubtracting:_dateCheckingIn] / 60.0f;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary * fromSuper = [[super dictionaryRepresentation] mutableCopy];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    if(!self.dateCheckingIn) return fromSuper;
    
    if(self.employeeId && self.employeeId.length > 0) {
        [fromSuper setObject:self.employeeId forKey:jkClockCloudObjectEmployeeId];
    }
    
    [formatter setDateFormat:CurrentDateFormat];
    [fromSuper setObject:[formatter stringFromDate:_dateCheckingIn] forKey:jkClockCloudObjectDate];
    
    [formatter setDateFormat:@"HH:mm"];
    [fromSuper setObject:[formatter stringFromDate:_dateCheckingIn] forKey:jkClockCloudObjectTimeIn];
    
    [formatter setDateFormat:@"EEE"];
    [fromSuper setObject:[formatter stringFromDate:_dateCheckingIn] forKey:jkClockCloudObjectDayOfWeek];
    
    if(_dateCheckingOut) {
        [formatter setDateFormat:@"HH:mm"];
        [fromSuper setObject:[formatter stringFromDate:_dateCheckingOut] forKey:jkClockCloudObjectTimeOut];
        _hoursWorked = [_dateCheckingOut minutesBySubtracting:_dateCheckingIn] / 60.0f;
        [fromSuper setObject:[NSString stringWithFormat:@"%.2f",_hoursWorked] forKey:jkClockCloudObjectHours_Worked];
    }
    
    return [NSDictionary dictionaryWithDictionary:fromSuper];
}

- (void)uploadData:(void (^)(NSError *))callback {
    NSMutableDictionary * dict = [[self dictionaryRepresentation] mutableCopy];
    [dict removeObjectForKey:jkCloudObjectId];
    
    NGHRCloudApi * api = [NGHRCloudApi sharedApi];
    NSURLRequest * request = [api requestWithMethod:@"POST" path:@"/rest/CLOUD/Time_Clock" parameters:dict];
    
    AFJSONRequestOperation * op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSAssert(response.statusCode == 200, @"");
        callback(nil);
        NSLog(@"%@", [JSON description]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        callback(nil);
        NSLog(@"%@", [JSON description]);
    }];
    
    [op start];
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