//
//  CH13AppDelegate.m
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "CH13AppDelegate.h"

#import "CH13MasterViewController.h"
#import "Session.h"

@implementation CH13AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _BOOKMARK_
    [MagicalRecord setupCoreDataStack];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    CH13MasterViewController *masterViewController = [[CH13MasterViewController alloc] initWithNibName:@"CH13MasterViewController" bundle:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self logAllRennesSessions];
}



///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Demo Request

_BOOKMARK_
- (void)logAllRennesSessions
{
    NSArray* array = [Session findByAttribute:@"city.name" withValue:@"Rennes" andOrderBy:@"date" ascending:NO];
    NSLog(@"Sessions in Rennes: %@", array);}

@end
