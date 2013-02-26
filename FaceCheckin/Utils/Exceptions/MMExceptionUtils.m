//
//  MMExceptionUtils.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/17/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "MMExceptionUtils.h"

@interface MMExceptionUtils ()

+ (void)raiseByName:(NSString *)name withReason:(NSString *)reason;

@end

@implementation MMExceptionUtils

+ (void)raiseByName:(NSString *)name withReason:(NSString *)reason {
    @throw [NSException exceptionWithName:name reason:reason userInfo:nil];
}

+ (void)raiseNotImplementedException:(NSString *)reason {
    [MMExceptionUtils raiseByName:@"NSNotImplementedException" withReason:reason];
}

+ (void)raiseInvalidAccessException:(NSString *)reason {
    [MMExceptionUtils raiseByName:@"NSInvalidAccessException" withReason:reason];
}

@end
