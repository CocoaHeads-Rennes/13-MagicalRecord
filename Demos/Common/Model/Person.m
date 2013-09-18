//
//  Person.m
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "Person.h"
#import "Session.h"


@implementation Person

@dynamic firstname;
@dynamic lastname;
@dynamic sessions;

- (NSString*)fullname
{
    return [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
}

@end
