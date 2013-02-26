//
//  UILabel+NGExtensions.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/26/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NGExtensions)

- (void)fitTextToWidth:(CGFloat)width;
- (void)fitTextToWidth:(CGFloat)width forFontName:(NSString *)fontName;

@end
