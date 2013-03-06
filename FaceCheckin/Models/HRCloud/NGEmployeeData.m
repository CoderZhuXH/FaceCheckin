//
//  NGEmployeeData.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/5/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGEmployeeData.h"

#import "NGHRCloudApi.h"

@implementation NGEmployeeData

+ (void)getEmployeeDataForEncryptedID:(NSString *)eid forCallback:(NGEmployeeDataCallback)callback {
    
    NSString * path = [NSString stringWithFormat:@"/rest/employees/%@", eid];
    
    [[NGHRCloudApi sharedApi] getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NGEmployeeData * data = [[NGEmployeeData alloc] initWithDictionary:responseObject];
        NSLog(@"Got object %@", responseObject);
        callback(data,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil,error);
    }];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _id                 = [dictionary   objectForKey:@"id"];
        _uri                = [dictionary   objectForKey:@"uri"];
        _isActive           = [[dictionary  objectForKey:@"active"] boolValue];
        _employeeNumber     = [dictionary   objectForKey:@"employeenumber"];
        _firstName          = [dictionary   objectForKey:@"firstname"];
        _lastName           = [dictionary   objectForKey:@"lastname"];
        _email              = [dictionary   objectForKey:@"email"];
    }
    return self;
}

@end
