//
//  NGDailyReportCell.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGDailyReportCell.h"

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


- (BOOL)shouldUpdateCell:(id)cellObject {
    BOOL shouldUpdate = [super shouldUpdateCell:cellObject];
    
    if(shouldUpdate) {
        
    }
    
    return shouldUpdate;
}

@end
