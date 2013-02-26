//
//  MMDomainObjectBase.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/19/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "BBDomainObjectBase.h"

@implementation BBDomainObjectBase

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return [NSDictionary dictionary];
}

@end