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
        _imageRecognizerTranslator = @{@"BrunoAlfirevic" : @"28902ae038ce43c0bfbff78dad1bad5a", @"BrunoBulic" : @"34d47b567419a34d8c0c39de5b060d4c"};
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
        _evaluationCycleDate= [dictionary   objectForKey:@"evaluationcycledate"];
        _position           = [[NGEmployeePosition alloc] initWithDictionary:[dictionary objectForKey:@"position"]];
        
        // BONUSSSSSSSSS
        _fastEmployeeNumber = [_employeeNumber integerValue];
    }
    return self;
}

@end


/*  "position": {
        "id": "b505d97d6f037bb77cb93430400b1e91",
        "uri": "http://api.qa.neogov.net/rest/position/b505d97d6f037bb77cb93430400b1e91",
        "code": "SSE",
        "title": "Senior Software Engineer"
    },
 */

@implementation NGEmployeePosition

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _positionId = [dictionary objectForKey:@"id"];
        _uri        = [dictionary objectForKey:@"uri"];
        _code       = [dictionary objectForKey:@"code"];
        _title      = [dictionary objectForKey:@"title"];
    }
    return self;
}

@end
