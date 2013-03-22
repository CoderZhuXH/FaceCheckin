//
//  NGLookalikesView.m
//  FaceCheckin
//
//  Created by Bruno Bulic on 3/18/13.
//  Copyright (c) 2013 Neogov. All rights reserved.
//

#import "NGLookalikesView.h"

@interface NGLookalikesView ()

@property (nonatomic, readonly) NSMutableArray * imageArray;

@property (nonatomic, strong) UICollectionView * collectionView;

- (void)commonInit;

@end

@implementation NGLookalikesView

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}


- (void)awakeFromNib {
    
}


@end
