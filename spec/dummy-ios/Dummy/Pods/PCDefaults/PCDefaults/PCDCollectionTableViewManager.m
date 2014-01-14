//
//  UIViewController+PCDCollectionTableView.m
//  FilterKit
//
//  Created by Tomas Spacek on 30/11/2013.
//  Copyright (c) 2013 Papercloud. All rights reserved.
//

#import "PCDCollectionTableViewManager.h"

@interface PCDCollectionTableViewManager () <NSFetchedResultsControllerDelegate>

@end

@implementation PCDCollectionTableViewManager

- (id)initWithDecoratedObject:(id<PCDCollectionTableViewManagerDataSource>)decoratedObject
            collectionManager:(PCDCollectionManager *)collectionManager
                    tableView:(UITableView *)tableView
{
    self = [self initWithDecoratedObject:decoratedObject];
    if (self) {
        self.collectionManager = collectionManager;
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

        __weak typeof(self) weakSelf = self;
        [self.collectionManager setUpdateBlock:^(NSArray *objects) {
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            // TODO: Error handling.
        }];

        [self.collectionManager.fetchedResultsController setDelegate:self];
        [self.collectionManager reload];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
    _returnDecorated(tableView, section)
#pragma clang diagnostic pop
    
    return self.collectionManager.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _returnDecorated(tableView, indexPath);
    return [self tableView:tableView contentCellForRowAtIndexPath:indexPath];
 }

/**
 This is intended to be overwritten by the decorated object. It's just here for default scaffolding.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView contentCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _returnDecorated(tableView, indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    
    id object = [self.collectionManager.objects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [object description];
    
    return cell;
}

/**
 This is intended to be overwritten by the decorator object. It's just here for default scaffolding.
 */
- (UIView *)tableViewPageLoadingView:(UITableView *)tableView
{
    UIView * loadingView = [UIView new];
    [loadingView setFrame:CGRectMake(.0, .0, CGRectGetWidth(tableView.bounds), 100.0)];
    [loadingView setBackgroundColor:[UIColor whiteColor]];
    
    UIActivityIndicatorView * activityIndicator = [UIActivityIndicatorView new];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [loadingView addSubview:activityIndicator];
    
    [activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    [loadingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[activityIndicator]-|"
                                                                        options:NSLayoutFormatAlignAllCenterY
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(activityIndicator)]];
    [loadingView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[activityIndicator]-|"
                                                                        options:NSLayoutFormatAlignAllCenterX
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(activityIndicator)]];
    return loadingView;
}

/**
 Load another page of results when we scroll to the bottom.
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    _callDecoratedThenReturn(tableView, cell, indexPath)
    
    if (self.collectionManager.paginator.isLoaded && self.collectionManager.paginator.hasNextPage) {
        
        if (indexPath.row >= (_collectionManager.paginator.perPage*_collectionManager.paginator.currentPage)-1) {
            [self.collectionManager.paginator cancel];
            [self.collectionManager.paginator loadNextPage];
            
            if (indexPath.row >= self.collectionManager.objects.count-1) {
                UIView * view = [self tableViewPageLoadingView:tableView];
                [tableView setTableFooterView:view];
            }
        }
    }
}

#pragma mark
#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self.tableView setTableFooterView:nil];
}

@end