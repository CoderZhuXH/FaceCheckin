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

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@end

@implementation NGProfileInfo

static NSArray * observableKeys;
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observableKeys =  @[@"hoursWorked", @"profileImage"];
    });
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)customInit {

    self.coreCalendarLabel.font = [UIFont fontWithName:@"GothamBook" size:14.0];
    self.hoursLabel.text = @"-- hours";
    
    // Batch call bitch
    self.positionLabel.font     = [UIFont fontWithName:@"GothamNarrow-Medium" size:17.0];
    
    self.nameSurnameLabel.font  = [UIFont fontWithName:@"GothamNarrow-Bold" size:20.0];
    self.hoursLabel.font        = [UIFont fontWithName:@"GothamNarrow-Bold" size:24.0];
    
    [self addObserver:self forKeyPath:@"hoursWorked" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"profileImage" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if([keyPath isEqualToString:@"hoursWorked"]) {
        self.hoursLabel.text = [NSString stringWithFormat:@"%.2f hours", self.hoursWorked];
    }
    
    if([keyPath isEqualToString:@"profileImage"]) {
        [self loadImage:self.profileImage];
    }
}

- (void)loadPerfsFromProfile:(NGEmployeeData *)employeeData {
    self.nameSurnameLabel.text  = employeeData.firstName;
    self.positionLabel.text     = employeeData.position.title;
}

- (void)loadImage:(UIImage *) image {
    [self.profileImageView setImage:image];
}

#pragma mark - Release observers from SELF!

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"hoursWorked"];
    [self removeObserver:self forKeyPath:@"profileImage"];
}

@end
