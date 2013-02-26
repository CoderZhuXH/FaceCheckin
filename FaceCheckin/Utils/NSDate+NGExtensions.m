//
//  NSDate+NGExtensions.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NSDate+NGExtensions.h"

@implementation NSDate (NGExtensions)

- (NSDateComponents *)dateComponents {
    NSInteger cEnum = NSYearCalendarUnit |  NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    return [calendar components:cEnum fromDate:self];
}

@end
