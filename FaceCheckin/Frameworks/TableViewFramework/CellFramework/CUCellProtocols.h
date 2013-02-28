//
//  CUCellProtocols.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/14/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Cell configuration protocols */

@protocol CUCellItem <NSObject>

- (Class)classForCellItem;

@end


@protocol CUCell <NSObject>

- (BOOL)shouldUpdateCell:(id)cellObject;

@end

@protocol CUTableViewDelegateProtocol <NSObject>
@optional
- (void)tableView:(UITableView *)tableView selectedObject:(id<CUCellItem>)object atIndexPath:(NSIndexPath *)indexPath;
@end

/* Cell configuration delegate */

@protocol CUCellFrameworkDelegate <NSObject>
- (UITableViewCell *)CUTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath forObject:(id)userData;
@end

