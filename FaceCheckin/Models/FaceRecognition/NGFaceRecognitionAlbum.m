//
//  NGFaceRecognitionAlbum.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/4/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGFaceRecognitionAlbum.h"

@implementation NGFaceRecognitionAlbum

- (id)init {
    [MMExceptionUtils raiseInvalidAccessException:@"No init yourself."];
    return nil;
}

- (id)initPrivate:(NSString *)albumName withKey:(NSString *)key
{
    self = [super init];
    if (self) {
        _albumName = albumName;
        _albumKey = key;
    }
    
    return self;
}

+ (NGFaceRecognitionAlbum *)neogov {
    NGFaceRecognitionAlbum * fra = [[NGFaceRecognitionAlbum alloc] initPrivate:@"NEOGOV" withKey:@"b608892f98589bca946995e20e621a137cbb657bab162084050b8566efabb035"];
    return fra;
}

@end
