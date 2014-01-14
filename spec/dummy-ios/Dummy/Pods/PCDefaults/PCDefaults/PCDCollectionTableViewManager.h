//
//  UIViewController+PCDCollectionTableView.h
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCDCollectionManager.h"
#import "PCDAbstractDecorator.h"

/**
 Default UITableViewDelegate and UITableViewDataSource for a paginated list of objects.
 Handles showing a 'loading' row, and detecting when to load the next page of results.
 */

@protocol PCDCollectionTableViewManagerDataSource <NSObject, UITableViewDelegate>
@optional
- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)tableViewPageLoadingView:(UITableView *)tableView;
@end

@interface PCDCollectionTableViewManager : PCDAbstractDecorator <UITableViewDataSource, UITableViewDelegate>

- (id)initWithDecoratedObject:(id<PCDCollectionTableViewManagerDataSource>)decoratedObject collectionManager:(PCDCollectionManager *)collectionManager tableView:(UITableView *)tableView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PCDCollectionManager *collectionManager;

@end

