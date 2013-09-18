//
//  CH13MasterViewController.m
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "CH13MasterViewController.h"
#import "CH13SessionDetailViewController.h"

#import "Session.h"
#import "City.h"
#import "Person.h"

@interface CH13MasterViewController ()
@property (strong, nonatomic) IBOutlet UIView *actionsView;
@end

@implementation CH13MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"MagicalRecord";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.tableHeaderView = self.actionsView;
}

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CH13ListBaseProtocol

static NSString* const kDefaultCityName = @"Rennes";
static NSString* const kDefaultSessionName = @"Nouvelle Session";

- (void)insertNewObject
{
    City* defaultCity = [self findOrCreateCityWithName:kDefaultCityName];
    NSManagedObject* newSession = [self newSessionWithSubject:kDefaultSessionName date:[NSDate date] summary:nil lecturer:nil];
    [newSession setValue:defaultCity forKey:@"city"];
    [newSession.managedObjectContext save:nil];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = session.subject;
    cell.detailTextLabel.text = session.dateString;
}

- (void)showObjectDetails:(id)object
{
    CH13SessionDetailViewController* vc = [CH13SessionDetailViewController new];
    vc.session = object;
    [self.navigationController pushViewController:vc animated:YES];
}


///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CoreData Mess

_BOOKMARK_
- (IBAction)fillObjectGraph
{
    // Fill database with some default objects
    NSDateFormatter* df = [NSDateFormatter new];
    df.dateFormat = @"dd/MM/yy";
    
    /* Rennes */
    Person* isoftom = [self findOrCreatePersonWithFirstName:@"Thomas" lastName:@"Dupont"];
    NSManagedObject* rennes13a = [self newSessionWithSubject:@"CocoaPods"
                                                        date:[df dateFromString:@"19/09/13"]
                                                     summary:@"CocoaPods, la meilleure façon de gérer les librairies et dépendances"
                                                    lecturer:isoftom];
    
    Person* alisoftware = [self findOrCreatePersonWithFirstName:@"Olivier" lastName:@"Halligon"];
    NSManagedObject* rennes13b = [self newSessionWithSubject:@"MagicalRecord"
                                                        date:[df dateFromString:@"19/09/13"]
                                                     summary:@"MagicalRecord, simplifions Core Data"
                                                    lecturer:alisoftware];
    
    City* rennes = [self findOrCreateCityWithName:@"Rennes"];
    [rennes addSessions:[NSSet setWithArray:@[rennes13a, rennes13b]]];
    
    /* Toulouse */
    Person* macmation = [self findOrCreatePersonWithFirstName:@"Guillaume" lastName:@"Cerquant"];
    NSManagedObject* toulouse0913a = [self newSessionWithSubject:@"CocoaPods"
                                                            date:[df dateFromString:@"19/09/13"]
                                                         summary:@"CocoaPods, un outil permettant d’intégrer facilement des librairies externes dans nos projets"
                                                        lecturer:macmation];
    
    NSManagedObject* toulouse0313 = [self newSessionWithSubject:@"Accessibilité"
                                                           date:[df dateFromString:@"14/03/13"]
                                                        summary:@"L'Accessibilité avec Cocoa"
                                                       lecturer:macmation];
    
    Person* dvial = [self findOrCreatePersonWithFirstName:@"Dominique" lastName:@"Vial"];
    NSManagedObject* toulouse0913b = [self newSessionWithSubject:@"Novae"
                                                            date:[df dateFromString:@"19/09/13"]
                                                         summary:@"Chronique de la création d'un jeu iOS"
                                                        lecturer:dvial];
    
    City* toulouse = [self findOrCreateCityWithName:@"Toulouse"];
    [toulouse addSessions:[NSSet setWithArray:@[toulouse0313, toulouse0913a, toulouse0913b]]];
    
    /* Paris */
    Person* mgodard = [self findOrCreatePersonWithFirstName:@"Mathieu" lastName:@"Godard"];
    NSManagedObject* paris37b = [self newSessionWithSubject:@"CocoaPods"
                                                       date:[df dateFromString:@"18/02/13"]
                                                    summary:@"SmallTalk d'Introduction à CocoaPods"
                                                   lecturer:mgodard];
    
    City* paris = [self findOrCreateCityWithName:@"Paris"];
    [paris addSessions:[NSSet setWithArray:@[paris37b]]];
    
    [self.fetchedResultsController.managedObjectContext save:nil];
}

_BOOKMARK_
- (IBAction)emptyGraphObject
{
    [City truncateAll];
    [Session truncateAll];
    [Person truncateAll];
}

_BOOKMARK_
- (NSManagedObject*)newSessionWithSubject:(NSString*)subject
                                     date:(NSDate*)date
                                  summary:(NSString*)summary
                                 lecturer:(Person*)lecturer
{
    Session* session = [Session createEntity];
    session.subject = subject;
    session.date = date;
    session.summary = summary;
    session.lecturer = lecturer;
    return session;
}

_BOOKMARK_
- (City*)findOrCreateCityWithName:(NSString*)cityName
{
    City* foundCity = [City findFirstByAttribute:@"name" withValue:cityName];
    if (!foundCity)
    {
        foundCity = [City createEntity];
        foundCity.name = cityName;
    }
    return foundCity;
}

_BOOKMARK_
- (Person*)findOrCreatePersonWithFirstName:(NSString*)firstName lastName:(NSString*)lastName
{
    NSPredicate* personPredicate = [NSPredicate predicateWithFormat:@"firstname == %@ AND lastname == %@", firstName, lastName];
    Person* person = [Person findFirstWithPredicate:personPredicate];
    if (!person)
    {
        person = [Person createEntity];
        person.firstname = firstName;
        person.lastname = lastName;
    }
    return person;
}

_BOOKMARK_
- (NSFetchedResultsController *)buildFetchedResultsController
{
    return [Session MR_fetchAllSortedBy:@"date" ascending:NO withPredicate:nil groupBy:@"city.name" delegate:self];
}


@end
