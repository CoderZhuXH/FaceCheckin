//
//  NGCheckinData.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCheckinData.h"

@implementation NGCheckinData

- (id)initWithCheckIn:(NSDate *)date andCheckout:(NSDate *)checkout {
    self = [super initWithDictionary:nil];
    
    if (self) {
        _checkIn = date;
        _checkIn = checkout;
    }
    
    return self;
}

@end
