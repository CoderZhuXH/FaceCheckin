//
//  NGHRCloudApi.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/5/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"
#import "AFHTTPClient.h"

@interface NGHRCloudApi : AFHTTPClient

+ (NGHRCloudApi *)sharedApi;

@end

@interface NGHRCloudUploadApi : AFHTTPClient

+ (NGHRCloudUploadApi *)sharedApi;

@end
