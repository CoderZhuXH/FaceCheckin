//
//  VGMultistateButton.m
//  Vintage Gizmo
//
//  Created by Bruno Bulić on 11/27/12.
//  Copyright (c) 2012 Holos One. All rights reserved.
//

#import "VGMultistateButton.h"

@interface VGMultistateButton ()

@property (nonatomic, retain) NSString * normalName;
@property (nonatomic, retain) NSString * highlightedName;
@property (nonatomic, retain) NSString * selectedName;
@property (nonatomic, retain) NSString * selectedHighlightedName;

@property (nonatomic, assign) NSString * currentStateName;
@property (nonatomic, assign) NSString * nextStateName;

- (void)fillDataFromDescriptor:(VGMultistateButtonStateDescriptor *)descriptor;
- (void)initDataFromArray:(NSArray *)array;

@end

@implementation VGMultistateButton {
    BOOL _askedStateChangeDuringDelegate;
}

- (void)initDataFromArray:(NSArray *)array {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:array.count];
    
    for(VGMultistateButtonStateDescriptor * desc in array) {
        
        [dict setObject:desc forKey:desc.stateName];
    }
    
    BOOL allAreFound = YES;
    for (VGMultistateButtonStateDescriptor * desc in array) {
        
        VGMultistateButtonStateDescriptor * exists = [dict objectForKey:desc.nextState];
        allAreFound = allAreFound && (exists != nil);
    }
    
    if(!allAreFound)
        [MMExceptionUtils raiseInvalidAccessException:@"Not all next states exist in dictionary"];
    
    _stateDescriptors = [NSDictionary dictionaryWithDictionary:dict];
    _stateList = [NSArray arrayWithArray:array];
}

- (void)awakeFromNib {
    [self addTarget:self action:@selector(ontap:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initButtonWithStates:(NSArray *)stateDescriptorArray {
    
    self = [super initWithFrame:CGRectMake(0,0,56,56)];
    
    if (self) {
        
        [self awakeFromNib];
        [self initDataFromArray:stateDescriptorArray];
        
        VGMultistateButtonStateDescriptor *currentDescriptor = [stateDescriptorArray objectAtIndex:0];
        [self fillDataFromDescriptor:currentDescriptor];
    }
    
    return self;
}

- (void)forceStates:(NSArray *)stateDescriptionArray {
    [self initDataFromArray:stateDescriptionArray];
    
    VGMultistateButtonStateDescriptor * firstDescriptor = [stateDescriptionArray objectAtIndex:0];
    
    [self forceButtonToState:firstDescriptor.stateName];
}


- (void)ontap:(id)target {
    NSString * currentState = self.currentStateName;
    
    VGMultistateButtonStateDescriptor * nextDescriptor = [self.stateDescriptors objectForKey:self.nextStateName];
    
    if(!_askedStateChangeDuringDelegate)
        [self fillDataFromDescriptor:nextDescriptor];
    
    // going to change bitch
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(button:selectedWithState:)]) {
            [self.delegate button:self selectedWithState:currentState];
        }
    }
    
    // going to change bitch
    if(self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(button:didChangeStateTo:)]) {
            [self.delegate button:self didChangeStateTo:self.currentStateName];
        }
    }
}

- (void)forceButtonToState:(NSString *)stateName {
    VGMultistateButtonStateDescriptor * descriptor = [self.stateDescriptors objectForKey:stateName];
    
    if(descriptor) {
        [self fillDataFromDescriptor:descriptor];
    }
    else {
        [MMExceptionUtils raiseInvalidAccessException:@"A state you are trying to set to doesn't exist!"];
    }
}

- (void)fillDataFromDescriptor:(VGMultistateButtonStateDescriptor *)descriptor {
    
    [self setImage:[UIImage imageNamed:descriptor.normalImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:descriptor.selectedImageName] forState:UIControlStateHighlighted];
    self.currentStateName = descriptor.stateName;
    self.nextStateName = descriptor.nextState;
}

@end

@implementation VGMultistateButtonStateDescriptor

- (id)initWithStateName:(NSString *)name withNextState:(NSString *)next withNormalImageName:(NSString *)ni andSelectedImageName:(NSString *)hiimName {
    
    self = [super init];
    if (self){
        _stateName = name;
        _nextState = next;
        _normalImageName = ni;
        _selectedImageName = hiimName;
    }
    
    return self;
}

@end