//
//  NGUserPanelController.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 2/28/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGBaseViewController.h"
#import "CUCellFramework.h"

@interface NGUserPanelController : NGBaseViewController<CUCellFrameworkDelegate>

@property (weak, nonatomic) IBOutlet        UIButton    * checkinButton;
@property (nonatomic, unsafe_unretained)    UIImage     * imageToShow;

@end
