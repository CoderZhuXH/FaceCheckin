//
//  NGProfileInfo.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGProfileInfo.h"
#import "NGEmployeeData.h"

#import "UILabel+NGExtensions.h"

@interface NGProfileInfo ()

@property (weak, nonatomic) IBOutlet UILabel * nameSurnameLabel;
@property (weak, nonatomic) IBOutlet UILabel * positionLabel;
@property (weak, nonatomic) IBOutlet UILabel * coreCalendarLabel;
@property (weak, nonatomic) IBOutlet UILabel * hoursLabel;

@property (weak, nonatomic) IBOutlet UIImageView * profileImage;

@end

@implementation NGProfileInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)customInit {

    self.coreCalendarLabel.font = [UIFont fontWithName:@"System" size:72.0];
    self.coreCalendarLabel.text = @"\u1F300 \u1F5FF";
    
    // Batch call bitch
    self.positionLabel.font     = [UIFont fontWithName:@"GothamNarrow-Medium" size:17.0];
    
    self.nameSurnameLabel.font  = [UIFont fontWithName:@"GothamNarrow-Bold" size:20.0];
    self.hoursLabel.font        = [UIFont fontWithName:@"GothamNarrow-Bold" size:24.0];
    
    [self addObserver:self forKeyPath:@"hoursWorked" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if([keyPath isEqualToString:@"hoursWorked"]) {
        self.hoursLabel.text = [NSString stringWithFormat:@"%.2f hours", self.hoursWorked];
    }
}

- (void)loadPerfsFromProfile:(NGEmployeeData *)employeeData {
    self.nameSurnameLabel.text  = employeeData.firstName;
    self.positionLabel.text     = employeeData.position.title;
// hope to get a pic...
//  self.profileImage.image     = [UIImage imageWithURL:URL];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
