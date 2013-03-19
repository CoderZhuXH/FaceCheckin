//
//  NGTextView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGTextField.h"

#define kNGTextViewTitleImagePropertyName @"titleImage"
#define kNGTextViewDefaultFrame CGRectMake(0, 0, 350, 64)


@interface NGTextField ()

+ (NSArray *)observableProperties;

@property (nonatomic, weak) UIImageView * leftImageView;

- (void)viewInit;
- (void)setupTitleImageFromImage:(UIImage *)image;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NGTextField

+ (NSArray *)observableProperties {
    static NSArray * observableProperties;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observableProperties = @[kNGTextViewTitleImagePropertyName];
    });
    
    return observableProperties;
}

- (id)initWithFrame:(CGRect)frame
{
    if(CGRectEqualToRect(frame, CGRectZero)) {
        self = [super initWithFrame:kNGTextViewDefaultFrame];
    } else {
        self = [super initWithFrame:frame];
    }
    
   
    if (self) {
        [self viewInit];
    }
    return self;
}

- (id)init {
    // it's gonna load with default frame
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [self viewInit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:kNGTextViewTitleImagePropertyName]) {
        [self setupTitleImageFromImage:self.titleImage];
    }
}


- (void)viewInit {

#pragma mark - observer registration
    NSArray * oo = [[self class] observableProperties];
    
    // register observer
    for (NSString * o in oo) {
        [self addObserver:self forKeyPath:o options:NSKeyValueObservingOptionNew context:nil];
    }
#pragma mark -
    
    self.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:18.0f];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    if(self.titleImage) {
        [self setupTitleImageFromImage:self.titleImage];
    } else {
        [self setupTitleImageFromImage:nil];
    }
    
    
}

- (void)setupTitleImageFromImage:(UIImage *)image {
    if (self.leftImageView == nil) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self setLeftView:imageView];
        self.leftImageView = imageView;
    }
    
    [self.leftImageView setImage:image];
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
