//
//  NGCoreTimer.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/25/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "BBObservableObject.h"

@class NGCoreTimer;

@protocol NGCoreTimerProcotol <BBListenerDelegate>

- (void)coreTimer:(NGCoreTimer *)timer timerChanged:(id)changedData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NGCoreTimer : BBObservableObject

+ (NGCoreTimer *)coreTimer;

@end
