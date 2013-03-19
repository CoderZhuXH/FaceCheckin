//
//  NGPopoverBackgroundView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGPopoverBackgroundView.h"

#define CONTENT_INSET 10.0
#define CAP_INSET 25.0
#define ARROW_BASE 25.0
#define ARROW_HEIGHT 25.0

@interface NGPopoverBackgroundView ()

@property (nonatomic, assign) UIPopoverArrowDirection   arrowDirectionBacking;
@property (nonatomic, assign) CGFloat                   arrowOffsetBacking;

@end

@implementation NGPopoverBackgroundView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.borderImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(CAP_INSET,CAP_INSET,CAP_INSET,CAP_INSET)]];
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-bg"]];
        
        [self addSubview:_borderImageView];
        [self addSubview:_arrowView];
        
    }
    return self;
}


+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);
}

+(CGFloat)arrowHeight{
    return ARROW_HEIGHT;
}

+(CGFloat)arrowBase{
    return ARROW_BASE;
}

- (UIPopoverArrowDirection)arrowDirection {
    return self.arrowDirectionBacking;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    self.arrowDirectionBacking = arrowDirection;
}

- (void)setArrowOffset:(CGFloat)arrowOffset {
    self.arrowOffsetBacking = arrowOffset;
}

- (CGFloat)arrowOffset {
    return self.arrowOffsetBacking;
}

-  (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat _height = self.frame.size.height;
    CGFloat _width = self.frame.size.width;
    CGFloat _left = 0.0;
    CGFloat _top = 0.0;
    CGFloat _coordinate = 0.0;
    CGAffineTransform _rotation = CGAffineTransformIdentity;
    
    
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            _arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
            
            
        case UIPopoverArrowDirectionDown:
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            _arrowView.frame = CGRectMake(_coordinate, _height, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI );
            break;
            
        case UIPopoverArrowDirectionLeft:
            _left += ARROW_BASE;
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset) - (ARROW_HEIGHT/2);
            _arrowView.frame = CGRectMake(0, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( -M_PI_2 );
            break;
            
        case UIPopoverArrowDirectionRight:
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset)- (ARROW_HEIGHT/2);
            _arrowView.frame = CGRectMake(_width, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI_2 );
            
            break;
        case UIPopoverArrowDirectionAny:
        case UIPopoverArrowDirectionUnknown:
            break;
    }
    
    _borderImageView.frame =  CGRectMake(_left, _top, _width, _height);
    
    
    [_arrowView setTransform:_rotation];
    
}

@end
