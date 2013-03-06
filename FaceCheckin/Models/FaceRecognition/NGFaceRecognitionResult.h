//
//  NGFaceRecognitionResult.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

@class NGFaceRecognitionRecognizeResult;
@class NGFaceRecognitionResult;

typedef void(^NGFaceRecognitionCallback)(NGFaceRecognitionResult *result, NSError * error);

@interface NGFaceRecognitionResult : NGDomainObjectBase

#define jkSkyBiometryResultField    @"result"
#define jkSkyBiometryUsageField     @"usage"
#define jkSkyBiometryPhotosField    @"photos"

@property (nonatomic, readonly) NSString        * result;
@property (nonatomic, readonly) NSDictionary    * usage;
@property (nonatomic, readonly) NSString        * nameSpace;

/// Contains @class NGFaceRecognitionPhotoResult
@property (nonatomic, readonly) NSArray * photos;

+ (void)getRecognitionResulsForImageData:(NSData *)imageData forNameSpace:(NSString *)nameSpace withResult:(NGFaceRecognitionCallback)cblk;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NGFaceRecognitionPhotoResult : NGDomainObjectBase

@property (nonatomic, readonly) NSString * imgUrlString;
@property (nonatomic, readonly) NSString * pid;
@property (nonatomic, readonly) NSString * tid;

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

@property (nonatomic, readonly) NSUInteger facesOnPicture;

- (NSArray *)getUUIDsForNamespace:(NSString *)nameSpace;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NGFaceRecognitionUUID : NGDomainObjectBase

@property (nonatomic, readonly) CGFloat confidence;
@property (nonatomic, readonly) NSString * uid;

@property (nonatomic, readonly) NSString * nameSpace;

- (NSString *)strippedUid;

@end
