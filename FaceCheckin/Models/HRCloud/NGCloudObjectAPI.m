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
#import "NGEmployeeData.h"

#import "NSDate+NGExtensions.h"
#import "AFNetworking.h"

@interface NGCloudObject ()

@end

@implementation NGCloudObject

+ (void)getCloudObjects:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPICallback)callback {
    
    NGHRCloudApi * api = [NGHRCloudApi sharedApi];
    
    NSString * pathToGet =  [NSString stringWithFormat:@"/rest/cloud/%@", cloudObjectName];
    NSDictionary * getArgs = @{@"pagenumber": [NSNumber numberWithInteger:1], @"perpage":[NSNumber numberWithInteger:100]};
    
    [api getPath:pathToGet parameters:getArgs success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Got response: %@", responseObject);
        
        NSAssert([responseObject isKindOfClass:[NSArray class]], @"responseObject must be of NSArray JSON and not %@", NSStringFromClass([responseObject class]));
        
        NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (NSDictionary * cloudObjectDatum in responseObject) {
            NGCloudObject * obj = [[[self class] alloc] initWithDictionary:cloudObjectDatum];
            obj->_secretCloudObjectName = cloudObjectName;
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
        
        NSDictionary * empDict = [dictionary objectForKey:jkCloudObjectEmployeeData];
        NSAssert(empDict != nil, @"Employee dict must exist!");
        
        _employeeData = [[NGCloudEmployeeData alloc] initWithDictionary:empDict];

        NSMutableDictionary * mutableMe = [dictionary mutableCopy];
        [mutableMe removeObjectsForKeys:@[
         jkCloudObjectId,
         jkCloudObjectEmployeeData,
         ]];
        
        _cloudObject = [NSDictionary dictionaryWithDictionary:mutableMe];
        _fastEmployeeNumber = [_employeeData.employeeNumber integerValue];
    }
    
    [self configureObject];
    return self;
}

- (void)configureObject {
    // using with inheritence, override
}

- (BOOL)isReadyToSend {
    return YES; // override?
}

#pragma mark - Services and support

- (NGCloudObject *)cloudObjectWithEmployeeIdAndName {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:2];
    if(self.employeeData) {
        [dict setObject:[self.employeeData dictionaryRepresentation] forKey:jkCloudObjectEmployeeData];
    }
    
    [dict setObject:[NSString string] forKey:jkCloudObjectId];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NGCloudObject *)templateWithEmployee:(NGEmployeeData *)employee {
    NSDictionary * cloudData = [[NGCloudEmployeeData cloudEmployeeDataFromEmployee:employee] dictionaryRepresentation];
    
    NSDictionary * dictionary = @{jkCloudObjectEmployeeData: cloudData, jkCloudObjectId: [NSString string]};
    NGCloudObject * newSelf = [[[self class] alloc] initWithDictionary:dictionary];
    
    return newSelf;
}

#pragma mark - TO JSON. First!

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:2 + self.cloudObject.count];
    NSAssert(self.employeeData != nil, @"Employee data must be valid to even try to implement an object!");
    
    // was scary because of typcasting, but is no longer scary :)
    NSMutableDictionary * empDict = [self.employeeData mutableDictionaryRepresentation];
    
    [dict setObject:self.objectId   forKey:jkCloudObjectId              ];
    [dict setObject:empDict         forKey:jkCloudObjectEmployeeData    ];

    // add other elements
    [dict addEntriesFromDictionary:self.cloudObject];
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


#pragma mark - Upload all data... MUST BE GENERIC!

- (void)uploadData:(NGCloudObjectAPISendDataCallback)callback {
    [self uploadDataForCloudObject:self->_secretCloudObjectName withCallback:callback];
}

- (void)uploadDataForCloudObject:(NSString *)cloudObjectName withCallback:(NGCloudObjectAPISendDataCallback)callback {

    if (![self isReadyToSend]) {
        NSError * error = [NSError errorWithDomain:NGCloudObjectCannotSendDesc code:NGCloudObjectCannotSendError userInfo:self.cloudObject];
        callback(nil, error);
        return;
    }
    
    NSMutableDictionary * dict = [[self dictionaryRepresentation] mutableCopy];
    
    [[dict objectForKey:jkCloudObjectEmployeeData] removeObjectForKey:jkCloudEmployeeDataName   ];
    [[dict objectForKey:jkCloudObjectEmployeeData] removeObjectForKey:jkCloudEmployeeDataNumber ];
    
    NSMutableURLRequest * request;
    
    if(self.objectId != nil && self.objectId.length > 0) {
        request = [self changeDataToDictionary:dict forCloudObjectName:cloudObjectName];
    } else {
        [dict removeObjectForKey:jkCloudObjectId]; // blank, so invalid
        request = [self createNewWithDictionary:dict forCloudObjectName:cloudObjectName];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"]; // override value to compensate for the API
    
    NSLog(@"Will send %@", [dict description]);
        
    AFJSONRequestOperation * op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSAssert(response.statusCode == 200, @"");
        callback(JSON,nil);
        if (JSON) {
            NSArray * arr = (NSArray *)JSON;
            self->_objectId = [[arr objectAtIndex:0] objectForKey:jkCloudObjectId];
        }
        NSLog(@"%@", [JSON description]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        callback(nil, error);
        NSLog(@"%@", [JSON description]);
    }];
    
    [op start];
}

- (NSMutableURLRequest *)createNewWithDictionary:(NSDictionary *)dict forCloudObjectName:(NSString *)str {
    
    NSAssert(str != nil && str.length >0 , @"Cloud object name cannot be nil!");
    
    NSString * urlReq = [NSString stringWithFormat:@"/rest/cloud/%@",str];
    NSMutableURLRequest * request = [[[NGHRCloudUploadApi sharedApi] requestWithMethod:@"POST" path:urlReq parameters:dict] mutableCopy];

    return request;

}

- (NSMutableURLRequest *)changeDataToDictionary:(NSDictionary *)dict forCloudObjectName:(NSString *)str {
    
    NSAssert(str != nil && str.length >0 , @"Cloud object name cannot be nil!");
    NSAssert([dict objectForKey:jkCloudObjectId] != nil && [[dict objectForKey:jkCloudObjectId] length] >0 , @"Cloud object must have a valid cloud object ID");
    
    NSString * urlReq = [NSString stringWithFormat:@"/rest/CLOUD/%@/%@",str, self.objectId];
    NSMutableURLRequest * request = [[[NGHRCloudUploadApi sharedApi] requestWithMethod:@"PUT" path:urlReq parameters:dict] mutableCopy];
    
    return request;
}

#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"Object ID:%@, Employee Name:%@, Employee number:%d, Cloud Object:%@", self.objectId, self.employeeData.nameAndSurname, self.fastEmployeeNumber, self.cloudObject];
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NGCloudEmployeeData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _employeeId         = [dictionary objectForKey:jkCloudEmployeeDataId];
        _employeeNumber     = [dictionary objectForKey:jkCloudEmployeeDataNumber];
        _nameAndSurname     = [dictionary objectForKey:jkCloudEmployeeDataName];
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dict setObject:self.employeeId     forKey:jkCloudEmployeeDataId];
    [dict setObject:self.employeeNumber forKey:jkCloudEmployeeDataNumber];
    [dict setObject:self.nameAndSurname forKey:jkCloudEmployeeDataName];
    
    return dict;
}

+ (NGCloudEmployeeData *)cloudEmployeeDataFromEmployee:(NGEmployeeData *)empData {
    
    NSDictionary * dict = @{
                            jkCloudEmployeeDataId: empData.employeeId,
                            jkCloudEmployeeDataName : [NSString stringWithFormat:@"%@ %@", empData.firstName, empData.lastName],
                            jkCloudEmployeeDataNumber : empData.employeeNumber
                            };
    
    return [[[self class] alloc] initWithDictionary:dict];
}

@end