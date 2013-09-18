//
//  CH13MasterViewController.h
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CH13SessionDetailViewController;

#import <CoreData/CoreData.h>
#import "CH13ListBaseViewController.h"

@interface CH13MasterViewController : CH13ListBaseViewController <CH13ListBaseProtocol>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
