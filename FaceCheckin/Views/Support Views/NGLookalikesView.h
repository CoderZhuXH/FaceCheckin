//
//  NGLookalikesView.h
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGLookalikesView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

- (void)addLookalikeElement:(NSString *)objectData withUrl:(NSURL *)imageUrl;
- (void)redraw;

@end

@interface NGLookalikeElement : NSObject

@property (nonatomic, strong) NSString  * objectData;
@property (nonatomic, strong) NSURL     * imageUrl;

@end
