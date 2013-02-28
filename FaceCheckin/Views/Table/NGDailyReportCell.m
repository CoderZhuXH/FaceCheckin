//
//  NGDailyReportCell.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyReportCell.h"
#import "NGDailyReportCellObject.h"
#import "NGDailyDataMock.h"

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
        self.hoursField.font = self.datumField.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:24];
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
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 4)];
        
        self.datumField.attributedText = string;
        self.hoursField.text = [NSString stringWithFormat:@"%.2f", [mock.dailyReportData hours]];
    }
    
    return shouldUpdate;
}

@end
