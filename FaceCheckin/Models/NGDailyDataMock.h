//
//  NGDailyDataMock.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDailyDataMock : NSObject

- (id)initWithCheckins:(NSArray *)checkins;

@property (nonatomic, strong) NSArray * checkins;

- (NSDate *)objectDate;
- (CGFloat)hours;

@end
