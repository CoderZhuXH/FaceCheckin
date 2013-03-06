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

static NSDictionary * _imageRecognizerTranslator;

+ (void)initialize {
    if(self == [NGEmployeeData class]) {
        _imageRecognizerTranslator = @{@"BrunoAlfirevic" : @"34d47b567419a34d8c0c39de5b060d4c", @"BrunoBulic" : @"28902ae038ce43c0bfbff78dad1bad5a"};
    }
}

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

+ (NSString *)encryptedIdForId:(NSString *)skyBiometryId {
    
    // do support checking!
    NSAssert(skyBiometryId != nil && skyBiometryId.length > 0, @"SkyBiometry ID must have a value");
    
    NSString * encriptedID = [_imageRecognizerTranslator objectForKey:skyBiometryId];
    
    // a default scenario
    if (!encriptedID) {
        encriptedID = skyBiometryId;
    }
    
    return encriptedID;
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
