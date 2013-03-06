//
//  NGFaceRecognitionAlbum.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGFaceRecognitionAlbum : NSObject

@property (nonatomic, readonly) NSString * albumName;
@property (nonatomic, readonly) NSString * albumKey;

+ (NGFaceRecognitionAlbum *)neogov;

@end
