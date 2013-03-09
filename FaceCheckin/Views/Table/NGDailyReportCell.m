//
//  NGDailyReportCell.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyReportCell.h"
#import "NGDailyReportCellObject.h"
#import "NGDailyTimeClockData.h"

#import "UILabel+NGExtensions.h"
#import <QuartzCore/QuartzCore.h>

@interface NGDailyReportCell ()

@property (weak, nonatomic) IBOutlet UILabel *datumField;
@property (weak, nonatomic) IBOutlet UILabel *hoursField;

@end

@implementation NGDailyReportCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.datumField.font = [UIFont fontWithName:@"GothamNarrow-Book" size:24];
        self.hoursField.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:24];

    }
    return self;
}


- (BOOL)shouldUpdateCell:(id)cellObject {
    BOOL shouldUpdate = [super shouldUpdateCell:cellObject];
    
    if(shouldUpdate) {
        
        NGDailyReportCellObject * mock = (NGDailyReportCellObject *)cellObject;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, MMM d"];
        NSString * weekday = [formatter stringFromDate:mock.dailyReportData.objectDate];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:weekday];
        
        UIColor * colorWithHsv = [UIColor colorWithHue:53.0f/360.0f saturation:0.05f brightness:0.69f alpha:1.0];
        [string addAttribute:NSForegroundColorAttributeName value:colorWithHsv range:NSMakeRange(0, 4)];
        
        self.datumField.attributedText = string;
        
        if(mock.dailyReportData.hours == 0)
        {
            self.hoursField.text = @"--";

        }
        else
        {
            self.hoursField.text = [NSString stringWithFormat:@"%.2f", [mock.dailyReportData hours]];

        }
        
    }
    
    return shouldUpdate;
}

@end
