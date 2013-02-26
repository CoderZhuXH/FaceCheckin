//
//  MMExceptionUtils.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/17/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMExceptionUtils : NSObject

+ (void)raiseNotImplementedException:(NSString *)reason;
+ (void)raiseInvalidAccessException:(NSString *)reason;

@end
