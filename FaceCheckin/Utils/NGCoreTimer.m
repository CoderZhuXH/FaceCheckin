//
//  NGCoreTimer.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGCoreTimer.h"
#import "BBObservableObject+ProtectedMethods.h"

#define kNGCoreTimerKey @"NGCoreTimerKey"

@interface NGCoreTimer ()

@property (nonatomic, readonly) NSTimer * mainTimer;

@end

@implementation NGCoreTimer


#pragma mark - Static accessors

static NGCoreTimer * coreTimer;
static NSArray * keys;

+ (NGCoreTimer *)coreTimer {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = [NSArray arrayWithObject:kNGCoreTimerKey];
        coreTimer = [[NGCoreTimer alloc] initPrivate];
    });
    
    return coreTimer;
}

+ (id)alloc {
    
    if(coreTimer) {
        [MMExceptionUtils raiseInvalidAccessException:@"Cannot allocate but once, using static accessor coreTimer."];
    }
    
    return [super alloc];
}

#pragma mark - Init specifics

- (id)init {
    [MMExceptionUtils raiseInvalidAccessException:@"Don't."];
    
    return nil;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        _mainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }
    
    return self;
}

#pragma mark - timer

- (void)timerTick:(id)data {
    [self invokeChange];
}

#pragma mark - Observable collection specifics

/// Just to make registering listener for this one type safe, as a hack for Obj-C that ISN'T!
- (void)registerListener:(id<NGCoreTimerProcotol>)delegate {
    [super registerListener:delegate];
    [self timerTick:nil];
}

-(NSArray *)supportedKeysForObject:(id<BBListenerDelegate>)object {
    return keys;
}

- (void)doInvocationForObject:(id<NGCoreTimerProcotol>)object forKeyOrNil:(NSString *)keyOrNil {
    
    if ([object respondsToSelector:@selector(coreTimer:timerChanged:)]) {
        [object coreTimer:self timerChanged:nil];
    }
    
}

#pragma mark -


- (void)dealloc {
    [self.mainTimer invalidate];
}

@end
