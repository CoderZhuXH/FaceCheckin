//
//  NGTimerArrow.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/12/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGNibView.h"

@interface NGTimerArrow : NGNibView

- (void)putCenterToPosition:(CGFloat)xposition;
- (void)drawDate:(NSDate *)date;

@end
