//
//  CH13DetailViewController.h
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface CH13SessionDetailViewController : UIViewController
@property (strong, nonatomic) Session* session;
@end
