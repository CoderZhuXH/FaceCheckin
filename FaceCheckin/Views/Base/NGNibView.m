//
//  NGNibView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGNibView.h"

@implementation NGNibView

#pragma mark - Init and prepare!

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadNib];
    }
    return self;
}

- (void)loadNib {
    // TODO fix stringish
    NSString * nibStuff = [self nibName];
    if (nibStuff && nibStuff.length > 0) {
        
        [[NSBundle mainBundle] loadNibNamed:nibStuff owner:self options:nil];
        [self addSubview:self.nibView];
    }
    
    [self customInit];
}

- (void)awakeFromNib {
    [self loadNib];
    self.nibView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - User sinks

- (void)customInit {
    
}

#pragma mark -

+ (NSString *)nibName {
    return NSStringFromClass([self class]);
}

- (NSString *)nibName {
    return [[self class] nibName];
}

@end
