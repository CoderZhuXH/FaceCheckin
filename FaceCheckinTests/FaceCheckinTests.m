//
//  FaceCheckinTests.m
//  FaceCheckinTests
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "FaceCheckinTests.h"
#import "NGDailyTimeClockData.h"
#import "NGCloudObjectAPI.h"
#import "NGCheckinData.h"

@implementation FaceCheckinTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testObjectGeneration
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"TimeClockMock" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    id array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    

    for (NSDictionary * dict in array) {
        
        NGTimeClockCloudObject * obj = [[NGTimeClockCloudObject alloc] initWithDictionary:dict];

        STAssertNotNil(obj.dateCheckingIn   , @"Should be somthing");
        STAssertNotNil(obj.dateCheckingOut  , @"Should be somthing");
        STAssertNotNil(obj.dayOfWeek        , @"Should be somthing");
        STAssertTrue(obj.hoursWorked > 0    , @"Should be positive and not %.2f", obj.hoursWorked);
        STAssertNotNil(obj.dayOfWeek        , @"Has version");
    }
}

- (void)testGeneratingTableData {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"TimeClockMock" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    id array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray * timeClockCloudObjects = [NSMutableArray arrayWithCapacity:[array count]];
    
    for (NSDictionary * dict in array) {
        
        NGTimeClockCloudObject * obj = [[NGTimeClockCloudObject alloc] initWithDictionary:dict];
        
        STAssertNotNil(obj.dateCheckingIn   , @"Should be somthing");
        STAssertNotNil(obj.dateCheckingOut  , @"Should be somthing");
        STAssertNotNil(obj.dayOfWeek        , @"Should be somthing");
        STAssertTrue(obj.hoursWorked > 0    , @"Should be positive and not %.2f", obj.hoursWorked);
        STAssertNotNil(obj.dayOfWeek        , @"Has version");
        
        [timeClockCloudObjects addObject:obj];
    }
    
    NSArray * result = [NGDailyTimeClockData createDailyClockDataFromCloudObjects:timeClockCloudObjects];
    
    for (NGDailyTimeClockData * data in result) {
        NSLog(@"For date: %@", data.objectDate);
        
        for (NGCheckinData * checkinData in data.checkins) {
            NSLog(@"Checked in: %@, checked out: %@", checkinData.checkIn, checkinData.checkOut);
        }
    }
    
}

@end
