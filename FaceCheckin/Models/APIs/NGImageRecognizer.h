//
//  NGImageRecognizer.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "AFHTTPClient.h"

@interface NGImageRecognizer : AFHTTPClient

+ (NGImageRecognizer *)sharedClient;

+ (NSDictionary *)baseArgs;

- (void)testAuth;

@end

@interface NGImageRecognizerRequest : NSObject

@end

@interface NGImageRecognizerResult : NSObject

@end
