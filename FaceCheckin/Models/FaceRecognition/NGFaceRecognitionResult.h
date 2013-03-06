//
//  NGFaceRecognitionResult.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

@class NGFaceRecognitionResult;
@class NGFaceRecognitionAlbum;

typedef void(^NGFaceRecognitionCallback)(NGFaceRecognitionResult *result, NSError * error);

@interface NGFaceRecognitionResult : NGDomainObjectBase

@property (nonatomic, strong) NSString * status;

/// Contains @class NGFaceRecognitionPhotoResult
@property (nonatomic, strong) NSArray * photosResultArray;

+ (void)getRecognitionResulsForImageData:(NSData *)imageData forNameSpace:(NSString *)nameSpace withResult:(NGFaceRecognitionCallback)cblk;

@end

@interface NGFaceRecognitionPhotoResult : NGDomainObjectBase

@property (nonatomic, readonly) NSString * imgUrlString;

/// Contains @class NSDictionary
@property (nonatomic, readonly) NSArray * tags;

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

@end

@interface NGFaceRecognitionUUID : NGDomainObjectBase

@property (nonatomic, readonly) CGFloat confidence;
@property (nonatomic, readonly) NSString * predictedPictureId;
@property (nonatomic, readonly) NSString * imageUUID;

@end
