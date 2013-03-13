//
//  NGNibView.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+NGExtensions.h"

@interface NGNibView : UIView

@property (nonatomic, strong) IBOutlet UIView * nibView;

- (void)customInit;

+ (NSString *)nibName;
- (NSString *)nibName;

@end
