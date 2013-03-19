//
//  NGDomainObjectBase.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

@implementation NGDomainObjectBase

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    return nil;
}

- (NSMutableDictionary *)mutableDictionaryRepresentation {
    
    id mutability = [self dictionaryRepresentation];
    
    if([mutability isKindOfClass:[NSMutableDictionary class]]) {
        return mutability;
    }
    
    return [mutability mutableCopy];
}

@end
