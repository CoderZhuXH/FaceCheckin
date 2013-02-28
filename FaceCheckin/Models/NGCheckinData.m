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
    
    if([date compare:checkout] != NSOrderedAscending) {
        raise(666);
    }
    
    if (self) {
        _checkIn = date;
        _checkOut = checkout;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Checkin - %@; Checkout - %@", _checkIn, _checkOut];
}

@end
