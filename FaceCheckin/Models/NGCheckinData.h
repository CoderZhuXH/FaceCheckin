//
//  NGCheckinData.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDomainObjectBase.h"

@interface NGCheckinData : NGDomainObjectBase

- (id)initWithCheckIn:(NSDate *)date andCheckout:(NSDate *)checkout;

@property (nonatomic, readonly) NSDate *checkIn;
@property (nonatomic, readonly) NSDate *checkOut;

@end
