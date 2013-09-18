//
//  Session.h
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City, Person;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) Person *lecturer;
@property (nonatomic, retain) City *city;


@property (atomic, readonly) NSString* dateString;
@property (atomic, readonly) NSString* shortDescription;

@end
