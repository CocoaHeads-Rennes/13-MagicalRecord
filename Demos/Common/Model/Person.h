//
//  Person.h
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSSet *sessions;

- (NSString*)fullname;

@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end
