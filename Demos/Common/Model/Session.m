//
//  Session.m
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "Session.h"
#import "City.h"
#import "Person.h"


@implementation Session

@dynamic date;
@dynamic subject;
@dynamic summary;
@dynamic lecturer;
@dynamic city;

- (NSString*)dateString
{
    static NSDateFormatter* df = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        df = [NSDateFormatter new];
        df.dateStyle = NSDateFormatterLongStyle;
        df.timeStyle = NSDateFormatterNoStyle;
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
    });
    
    return [df stringFromDate:self.date];
}

- (NSString*)shortDescription
{
    NSDateFormatter* df = [NSDateFormatter new];
    df.dateFormat = @"dd/MM/yyyy";
    return [NSString stringWithFormat:@"%@ (%@)", self.city.name, [df stringFromDate:self.date]];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@ %p \"%@\" on %@>", self.class, self, self.subject, self.dateString];
}

@end
