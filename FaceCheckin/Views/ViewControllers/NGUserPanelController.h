//
//  NGUserPanelController.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGBaseViewController.h"
#import "CUCellFramework.h"
#import "NGCoreTimer.h"
#import "VGMultistateButton+NGExtensions.h"


#define currentCheckinKey @"currentCheckinKey"

@interface NGUserPanelController : NGBaseViewController<CUCellFrameworkDelegate,NGCoreTimerProcotol,VGMultistateButtonDelegate>

@property (weak, nonatomic) IBOutlet        UIButton    * checkinButton;
@property (nonatomic, unsafe_unretained)    UIImage     * imageToShow;
@property (weak, nonatomic) IBOutlet        UILabel     * hourLabel;

@end
