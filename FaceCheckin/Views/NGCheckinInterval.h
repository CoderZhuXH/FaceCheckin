//
//  NGCheckinInterval.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGNibView.h"

@interface NGCheckinInterval : NGNibView

@property (nonatomic, readonly) CGFloat pixelsPerMinute;


- (void)setClockInDate:(NSDate *)date;
- (CGFloat)setClockOutDate:(NSDate *)date pixelsPerMinute:(CGFloat)ppm;

- (void)setPositionOnSlider:(CGFloat)xCoord;

@end
