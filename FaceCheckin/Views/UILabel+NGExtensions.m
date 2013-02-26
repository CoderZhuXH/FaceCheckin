//
//  UILabel+NGExtensions.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "UILabel+NGExtensions.h"

@implementation UILabel (NGExtensions)

- (void)fitTextToWidth:(CGFloat)width {
    
    //CALCULATE THE SPACE FOR THE TEXT SPECIFIED.
    
    [self setAdjustsFontSizeToFitWidth:YES];
    [self setMinimumScaleFactor:0.01f];
    
    CGRect r = self.frame;
    self.frame = CGRectMake(r.origin.x, r.origin.y, width, r.size.height);
}

- (void)fitTextToWidth:(CGFloat)width forFontName:(NSString *)fontName {
    
    self.font = [UIFont fontWithName:fontName size:100];
    [self fitTextToWidth:width];
}

@end
