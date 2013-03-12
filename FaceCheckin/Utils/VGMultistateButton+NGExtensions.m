//
//  VGMultistateButton+NGExtensions.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/11/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "VGMultistateButton+NGExtensions.h"

@implementation VGMultistateButton (NGExtensions)

+ (NSArray *)createClockinButtonStates {
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:3];
    
    VGMultistateButtonStateDescriptor * descriptor = [[VGMultistateButtonStateDescriptor alloc] initWithStateName:@"ClockIn" withNextState:@"ClockOut" withNormalImageName:@"ClockInButton-Normal" andSelectedImageName:@"ClockInButton-Pressed"];
    
    [array addObject:descriptor];
    
    descriptor = [[VGMultistateButtonStateDescriptor alloc] initWithStateName:@"ClockOut" withNextState:@"ClockIn" withNormalImageName:@"ClockOutButton-Normal" andSelectedImageName:@"ClockOutButton-Pressed"];
    
    [array addObject:descriptor];
    
        descriptor = [[VGMultistateButtonStateDescriptor alloc] initWithStateName:@"Done" withNextState:@"Done" withNormalImageName:@"DoneButton-Normal" andSelectedImageName:@"DoneButton-Pressed"];
    
    [array addObject:descriptor];
    
    return [NSArray arrayWithArray:array];
}

@end
