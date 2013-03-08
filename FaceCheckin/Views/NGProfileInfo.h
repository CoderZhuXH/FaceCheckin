//
//  NGProfileInfo.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/6/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGNibView.h"

@class NGEmployeeData;

@interface NGProfileInfo : NGNibView

- (void)loadPerfsFromProfile:(NGEmployeeData *)employeeData;

@property (atomic, assign) CGFloat hoursWorked;
@property (atomic, assign) UIImage * profileImage;

@end
