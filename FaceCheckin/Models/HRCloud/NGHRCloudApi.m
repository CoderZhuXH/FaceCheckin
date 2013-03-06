//
//  NGHRCloudApi.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/5/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGHRCloudApi.h"
#import "AFJSONRequestOperation.h"

#define kNGHRCloudApiBaseUrl @"http://api.qa.neogov.net"

@implementation NGHRCloudApi

+ (NGHRCloudApi *)sharedApi {
    static NGHRCloudApi * _backing;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _backing = [[NGHRCloudApi alloc] initWithBaseURL:[NSURL URLWithString:kNGHRCloudApiBaseUrl]];
    });
    
    return _backing;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self clearAuthorizationHeader];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setAuthorizationHeaderWithUsername:@"alexandergb@neogov.net" password:@"welcome"];
    }
    return self;
}

@end
