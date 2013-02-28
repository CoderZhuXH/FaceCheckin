//
//  CUTableViewDelegate+ProtectedMethods.h
//  mobileCrowdTest
//
//  Created by Bruno Bulić on 12/14/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//

#import "CUCellFramework.h"

@interface CUTableViewDelegate (ProtectedMethods)

@property (nonatomic, unsafe_unretained) CUCellDataSource *dataSource;

- (void)tableView:(UITableView *)tableView didSelectObject:(id<CUCellItem>)cellItem atIndexPath:(NSIndexPath *)indexPath;

@end
