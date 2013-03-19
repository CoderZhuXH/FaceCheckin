//
//  NGDomainObjectBase.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol NGDomainObject <NSObject>
@required
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@optional
- (NSDictionary *)dictionaryRepresentationWithUserData:(id)object;
- (NSMutableDictionary *)mutableDictionaryRepresentation;
- (id)initWithDictionary:(NSDictionary *)dictionary withUserData:(id)object;
@end

@interface NGDomainObjectBase : NSObject<NGDomainObject>

@end
