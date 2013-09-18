//
//  CH13ListBaseViewController.h
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CH13ListBaseViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@end

@protocol CH13ListBaseProtocol
- (NSFetchedResultsController *)buildFetchedResultsController;
- (void)insertNewObject;
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)showObjectDetails:(id)object;
@end
