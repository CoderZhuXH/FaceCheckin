//
//  MMObservableObject+ProtectedMethods.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "BBObservableObject.h"

@interface BBObservableObjectData : NSObject

@property (nonatomic, strong) id<BBListenerDelegate> invocationTarget;
@property (nonatomic, strong) NSArray * invokeKeys;

@end

@interface BBObservableObject (ProtectedMethods)

- (void)invokeChange;
- (void)invokeChangeForKey:(NSString *)key;

- (NSUInteger)listenerCount;

- (void)doInvocationForObject:(id<BBListenerDelegate>)object forKeyOrNil:(NSString *)keyOrNil;
- (NSArray *)supportedKeysForObject:(id<BBListenerDelegate>)object;


@end
