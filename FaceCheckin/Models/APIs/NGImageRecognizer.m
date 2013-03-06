//
//  NGImageRecognizer.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGImageRecognizer.h"
#import "AFJSONRequestOperation.h"

#define kLambdaLabsFaceRecognizerBase   @"https://lambda-face-recognition.p.mashape.com"
#define kSkyBiometryBaseUrl             @"http://api.skybiometry.com"

@implementation NGImageRecognizer

+ (NGImageRecognizer *)sharedClient {
    static NGImageRecognizer *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NGImageRecognizer alloc] initWithBaseURL:[NSURL URLWithString:kSkyBiometryBaseUrl]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        /*
         [self setDefaultHeader:@"X-Mashape-Authorization" value:kLambdaLabsProdKey];
         */
    }
    return self;

}

+ (NSDictionary *)baseArgs {
    return @{@"api_key": kSkyBiometryAPIKey, @"api_secret" : kSkyBiometryAPISecret};
}

- (void)testAuth {
    
    
    [self postPath:@"/fc/account/authenticate.json" parameters:[[self class] baseArgs]
           success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSAssert([[responseObject objectForKey:@"authenticated"] boolValue] == YES, @"Should be true this");
    }      failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSAssert(YES, @"Just failed with %@", [error description]);
    }];
    
}

@end
