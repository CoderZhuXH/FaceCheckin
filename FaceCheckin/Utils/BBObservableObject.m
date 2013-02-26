//
//  MMObservableObject.m
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/26/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "BBObservableObject.h"
#import "BBObservableObject+ProtectedMethods.h"
#import "MMExceptionUtils.h"

@implementation BBObservableObjectData


@end

@interface BBObservableObject ()

@property (nonatomic, strong) NSArray * invokerArray;

@end


@implementation BBObservableObject {
    NSObject * lockObject;
}

- (id)init {
    self = [super init];
    if(self) {
        lockObject = [[NSObject alloc] init];
        self.invokerArray = [NSArray array];
    }
    
    return self;
}

- (void)registerListener:(id<BBListenerDelegate>)delegate {
    NSArray * currentArrayOfListeners = nil;
    
    @synchronized(lockObject) {
        currentArrayOfListeners = [self.invokerArray copy];
        
        BOOL contains = NO;
        
        for (BBObservableObjectData *element in currentArrayOfListeners) {
            if([element.invocationTarget isEqual:delegate]) {
                contains = YES;
                break;
            };
        }
        
        if(!contains) {
            
            BBObservableObjectData * data = [[BBObservableObjectData alloc] init];
            
            NSArray * keyArrays = [self supportedKeysForObject:delegate];
            
            data.invocationTarget = delegate;
            data.invokeKeys = [NSArray arrayWithArray:keyArrays];
            self.invokerArray = [currentArrayOfListeners arrayByAddingObject:data];
        }
    }
}

- (void)unregisterListener:(id<BBListenerDelegate>)delegate {
    
    NSMutableArray * currentArrayOfListners = nil;
    
    @synchronized(lockObject) {
        currentArrayOfListners = [self.invokerArray mutableCopy];
        
        BBObservableObjectData * containable = nil;
        
        for (BBObservableObjectData *element in currentArrayOfListners) {
            if([element.invocationTarget isEqual:delegate]) {
                containable = element;
                break;
            };
        }
        
        if(containable) {
            [currentArrayOfListners removeObject:containable];
        }
        
        self.invokerArray = [NSArray arrayWithArray:currentArrayOfListners];
    }
}

@end

@implementation BBObservableObject (ProtectedMethods)

- (void)invokeChangeForKey:(NSString *)key {
    NSArray * array = nil;
    
    // if the key is nil, call for all keys
    if(key == nil) {
        [self invokeChange];
        return;
    }
    
    @synchronized(lockObject) {
        array = [self.invokerArray copy];
    }
    
    for (BBObservableObjectData * data in array) {
        
        if([data.invokeKeys containsObject:key]) {
            [self doInvocationForObject:data.invocationTarget forKeyOrNil:key];
        }
    }
}

- (NSUInteger)listenerCount {
    return self.invokerArray.count;
}

- (void)invokeChange {
    
    NSArray * array = nil;
    
    @synchronized(lockObject) {
        array = [self.invokerArray copy];
    }
    
    for (BBObservableObjectData * data in array) {
        [self doInvocationForObject:data.invocationTarget forKeyOrNil:nil];
    }
}

- (void)doInvocationForObject:(id<BBListenerDelegate>)object forKeyOrNil:(NSString *)keyOrNil {
    [MMExceptionUtils raiseInvalidAccessException:@"Inherit this method in your class"];
}

- (NSArray *)supportedKeysForObject:(id<BBListenerDelegate>)object {
    [MMExceptionUtils raiseInvalidAccessException:@"Inherit this method in your class"];
    
    return nil;
}

@end
