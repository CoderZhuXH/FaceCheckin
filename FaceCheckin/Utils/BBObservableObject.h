//
//  MMObservableObject.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBObservableObject;

@protocol BBListenerDelegate <NSObject>

@end


@interface BBObservableObject : NSObject

@property (nonatomic, unsafe_unretained) id<BBListenerDelegate> delegate;

- (void)registerListener:(id<BBListenerDelegate>)delegate;
- (void)unregisterListener:(id<BBListenerDelegate>)delegate;

@end
