//
//  NGTimerArrow.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/12/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGTimerArrow.h"

@interface NGTimerArrow ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end


@implementation NGTimerArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)customInit {
    self.timeLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:15];
    self.frame = self.nibView.frame;
}

- (void)putCenterToPosition:(CGFloat)xposition {
    
    [UIView animateWithDuration:0.3f animations:^{
        CGPoint newPoint = CGPointMake(xposition-self.frame.size.width/2.0f, self.frame.origin.y);
        [self moveToPoint:newPoint];
    }];
}

- (void)drawDate:(NSDate *)date {
    
    self.backgroundColor = [UIColor clearColor];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    
    NSString * format = [formatter stringFromDate:date];
    self.timeLabel.text = format;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.timeLabel.textColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // and now draw the Path!
    CGContextBeginPath      (context);
    CGContextMoveToPoint    (context, self.frame.size.width/2 -7, 20);  // top left
    CGContextAddLineToPoint (context, self.frame.size.width/2 +7, 20);  // top right
    CGContextAddLineToPoint (context, self.frame.size.width/2   , 29);  // bottom mid
    CGContextClosePath      (context                                );
    
    CGContextSetFillColorWithColor(context, self.timeLabel.textColor.CGColor);
    CGContextFillPath(context);
    
    CGContextMoveToPoint(context, self.frame.size.width/2, self.frame.size.height); //start at this point
    CGContextAddLineToPoint(context, self.frame.size.width/2, 28); //draw to this point
    CGContextStrokePath(context);
}


@end
