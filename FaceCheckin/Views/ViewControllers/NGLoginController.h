//
//  NGLoginController.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGBaseViewController.h"

typedef enum {
    NGLoginControllerModeOnboard,
    NGLoginControllerModeSignIn,
    NGLoginControllerModeDefault = NGLoginControllerModeSignIn,
} NGLoginControllerMode;


@interface NGLoginController : NGBaseViewController<UITextFieldDelegate, UIPopoverControllerDelegate>


@property (nonatomic, readonly) NGLoginControllerMode currentMode;

-(id)initWithLoginControllerMode:(NGLoginControllerMode)mode;

@end
