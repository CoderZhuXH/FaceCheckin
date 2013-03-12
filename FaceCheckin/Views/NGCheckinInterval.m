//
//  NGCheckinInterval.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NSDate+NGExtensions.h"

#import "NGCheckinInterval.h"
#import <QuartzCore/QuartzCore.h>

#define CheckpointBarHeight 80.0f
#define CheckpointBarWidth 3.0f

#define CheckpointRectAt(x,y) CGRectMake(x, y, CheckpointBarWidth, CheckpointBarHeight)
#define CheckpointColor [UIColor colorWithRed:213.0/255 green:210.0/255 blue:198.0/255 alpha:1.0f]
#define BGColor     [UIColor colorWithRed:244.0f/255 green:241.0f/255 blue:227.0f/255 alpha:1]

@interface NGCheckinInterval ()

////////////////////////////////////////////////// -> GUI elements

@property (weak, nonatomic) IBOutlet UILabel *inTime;
@property (weak, nonatomic) IBOutlet UILabel *outTime;
@property (weak, nonatomic) IBOutlet UILabel *totalCheckinTime;

@property (assign, nonatomic) CGFloat controlWidth;

////////////////////////////////////////////////// -> Busniess elements

@property (strong, nonatomic) NSDate * startDate;
@property (strong, nonatomic) NSDate * endDate;

@end

@implementation NGCheckinInterval

- (void)setPositionOnSlider:(CGFloat)xCoord {
    self.frame = CGRectMake(xCoord, 0, self.frame.size.width, self.frame.size.height);
}

- (void)customInit {
    /*
    self.inLabel.font   = self.outLabel.font    = [UIFont fontWithName:@"GothamNarrow-Medium" size:15];
     */
    self.inTime.font    = self.outTime.font     = [UIFont fontWithName:@"GothamNarrow-Medium" size:15];
    self.totalCheckinTime.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:20.0f];
    
    self.outTime.hidden = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.nibView.backgroundColor = [UIColor clearColor];
    
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // default frame goes here
    self.frame = CGRectMake(0, 0, self.nibView.bounds.size.width,self.nibView.bounds.size.height);
}

- (NSString*) _formatDate:(NSDate *)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H:mm"];
    return [formatter stringFromDate:date];
}

- (void)setClockInDate:(NSDate *)date {
    
    self.startDate = date;
    
    CALayer * lyr = [CALayer layer];
    lyr.backgroundColor = CheckpointColor.CGColor;
    lyr.frame = CheckpointRectAt(0, 0);
    
    [self.layer addSublayer:lyr];
    
    self.inTime.text = [self _formatDate:self.startDate];
}

- (CGFloat)setClockOutDate:(NSDate *)date pixelsPerMinute:(CGFloat)ppm {
    self.endDate = date;
    
    NSInteger minutesSirMinutes = [self.endDate minutesBySubtracting:self.startDate];
    self.frame = CGRectMake(self.frame.origin.x, 0, minutesSirMinutes * ppm, self.frame.size.height);
    
    CALayer * lyr       = [CALayer layer];
    lyr.backgroundColor = CheckpointColor.CGColor;
    lyr.frame           = CheckpointRectAt(self.frame.size.width - CheckpointBarWidth, 0);
    [self.layer addSublayer:lyr];
    
    self.nibView.backgroundColor    = BGColor;
    self.backgroundColor            = BGColor;
    
    self.outTime.hidden     = NO;
    self.outTime.text = [self _formatDate:self.endDate];
    
    NSInteger difference = [self.endDate minutesBySubtracting:self.startDate];
    NSString * output = [[self class] formatHMSForMinuteDifference:difference];
    
    self.totalCheckinTime.text = output;
    
    return minutesSirMinutes * ppm;
}

+ (NSString *)formatHMSForMinuteDifference:(NSInteger)minuteDifference {
    NSDateComponents * components = [[NSDateComponents alloc] init];
    components.minute = minuteDifference;
    
    NSDate *startDate = [[NSDate date] dateByStrippingHours];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    startDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
    
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"h'h' m'm'"];
    
    return [formatter stringFromDate:startDate];

}

@end
