//
//  MMDomainObject.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/13/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBDomainObject <NSObject>

@required
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;
@optional
- (id)initWithDictionary:(NSDictionary *)dictionary withUserData:(id)userData;
@end