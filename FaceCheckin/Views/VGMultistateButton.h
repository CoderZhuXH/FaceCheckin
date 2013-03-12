//
//  VGMultistateButton.h
//  Vintage Gizmo
//
//  Created by Bruno Bulić on 11/27/12.
//  Copyright (c) 2012 Holos One. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VGMultistateButton;

@protocol VGMultistateButtonDelegate <NSObject>
@optional
- (void)button:(VGMultistateButton *)button selectedWithState:(NSString *)state;
- (void)button:(VGMultistateButton *)button didChangeStateTo:(NSString *)state;

@end

@interface VGMultistateButton : UIButton

@property (nonatomic, readonly) NSDictionary * stateDescriptors;
@property (nonatomic, readonly) NSArray * stateList;
@property (nonatomic, unsafe_unretained) id<VGMultistateButtonDelegate> delegate;

- (id)initButtonWithStates:(NSArray *)stateDescriptorArray;
- (void)forceStates:(NSArray *)stateDescriptionArray;

- (void)forceButtonToState:(NSString *)stateName;

@end

@interface VGMultistateButtonStateDescriptor : NSObject

@property (nonatomic, readonly) NSString *stateName;
@property (nonatomic, readonly) NSString *nextState;
@property (nonatomic, readonly) NSString *normalImageName;
@property (nonatomic, readonly) NSString *selectedImageName;

- (id)initWithStateName:(NSString *)name withNextState:(NSString *)next withNormalImageName:(NSString *)ni andSelectedImageName:(NSString *)hiimName;

@end