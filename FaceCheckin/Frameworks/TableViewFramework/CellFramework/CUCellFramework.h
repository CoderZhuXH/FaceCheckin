//
//  CUCellFramework.h
//  Cuepid
//
//  Created by Bruno Bulić on 12/6/12.
//  Copyright (c) 2012 HolosOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUCellProtocols.h"



@protocol CUMutableCellFrameworkDelegate <CUCellFrameworkDelegate>

- (void)CUTableView:(UITableView *)tableView object:(id<CUCellItem>)object isRemovedAtPath:(NSIndexPath *)indexPath;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CUCellDataSource : NSObject<UITableViewDataSource>

- (id)initWithDelegate:(id<CUCellFrameworkDelegate>)delegate;
- (id)initWithArray:(NSArray *)array withDelegate:(id<CUCellFrameworkDelegate>)delegate;
- (id)initWithSectionedArray:(NSArray *)array withDelegate:(id<CUCellFrameworkDelegate>)delegate;

- (id<CUCellItem>)itemForIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, unsafe_unretained) id<CUCellFrameworkDelegate> delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CUMutableCellDataSource : CUCellDataSource

- (void)addObject:(id<CUCellItem>)object toIndexPath:(NSIndexPath *)indexPath;
- (void)removeObject:(id<CUCellItem>)object;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, unsafe_unretained) id<CUMutableCellFrameworkDelegate> delegate;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////


@interface CUCellGenerator : NSObject

+ (UITableViewCell *)CUTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id<CUCellItem>)userData;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface CUTableViewDelegate : NSObject<UITableViewDelegate>

- (id)initWithDataSource:(CUCellDataSource *)dataSource;

@property (nonatomic, unsafe_unretained) id<CUTableViewDelegateProtocol> delegate;

@end