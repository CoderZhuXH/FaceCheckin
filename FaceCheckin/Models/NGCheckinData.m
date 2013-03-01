//
//  NGCheckinData.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCheckinData.h"
#import "NSDate+NGExtensions.h"

@implementation NGCheckinData {
    CGFloat _hours;
}

- (id)initWithCheckIn:(NSDate *)date andCheckout:(NSDate *)checkout {
    self = [super initWithDictionary:nil];
    
    if([date compare:checkout] != NSOrderedAscending) {
        raise(666);
    }
    
    if (self) {
        _checkIn = date;
        _checkOut = checkout;
        _hours = -1;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Checkin - %@; Checkout - %@", _checkIn, _checkOut];
}

- (CGFloat)hours {
    if(_hours == -1) {
        _hours = (CGFloat)[_checkOut secondsBySubtracting:_checkIn]/3600;
    }
    
    return _hours;
}

- (CGFloat)minutes {
    
    CGFloat hours = [self hours];
    return hours * 60;
}

@end
