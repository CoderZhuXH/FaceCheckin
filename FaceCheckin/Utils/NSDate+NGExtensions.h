//
//  NSDate+NGExtensions.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HOURS(x) (3600 * (x))
#define MINUTES(x) (60 * (x))

@interface NSDate (NGExtensions)

- (NSDateComponents *)dateComponents;

- (NSDate *)dateByStrippingHours;
+ (NSDate *)dateFromComponentsGregorian:(NSDateComponents *)components;
- (NSInteger)secondsBySubtracting:(NSDate *)other;

@end
