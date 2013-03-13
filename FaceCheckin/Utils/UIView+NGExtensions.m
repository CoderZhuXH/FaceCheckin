//
//  UIView+NGExtensions.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/12/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "UIView+NGExtensions.h"

@implementation UIView (NGExtensions)

- (void)moveToPoint:(CGPoint)point {
    CGRect frame = self.frame;
    
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    
    self.frame = frame;
}

- (void)moveByDeltas:(CGPoint)point {
    CGRect frame = self.frame;
    
    frame = CGRectOffset(frame, point.x, point.y);
    
    self.frame = frame;
}

@end
