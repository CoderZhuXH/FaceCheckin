//
//  CUCellBase.m
//  Cuepid
//
//  Created by Bruno Bulić on 12/6/12.
//  Copyright (c) 2012 HolosOne. All rights reserved.
//

#import "CUCellBase.h"

@interface CUCellBase ()

- (void)loadFromNib;

@end

@implementation CUCellBase

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadFromNib];
    }
    return self;
}

- (void)loadFromNib {
    
    NSString *nibName = [self nibName];
    
    if(nibName.length > 0) {
        [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    }
    
    if(self.nibView) {
        self.frame = self.nibView.frame;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.nibView];
        [self.contentView bringSubviewToFront:self.nibView];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)nibName {
    return NSStringFromClass([self class]);
}

+ (NSString *)nibName {
    return [NSString string];
}

- (BOOL)shouldUpdateCell:(id)cellObject {
    
    if (cellObject == self.userData) {
        return NO;
    }
    
    _userData = cellObject;
    return YES;
}

@end
