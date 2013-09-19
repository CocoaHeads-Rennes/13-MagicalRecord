//
//  CH13DetailViewController.m
//  CocoaHeads Rennes #13
//
//  Created by Olivier Halligon on 08/09/13.
//  Copyright (c) 2013 AliSoftware. All rights reserved.
//

#import "CH13SessionDetailViewController.h"
#import <CoreData/CoreData.h>

#import "Session.h"
#import "City.h"
#import "Person.h"

@interface CH13SessionDetailViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *subjectField;
@property (weak, nonatomic) IBOutlet UITextView *summaryField;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UITextView *similarSessionsField;
@property (weak, nonatomic) IBOutlet UIButton *lecturerButton;
@end

@implementation CH13SessionDetailViewController

#pragma mark - Managing the detail item

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Session";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIDatePicker* picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr"];
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateField.inputView = picker;
    
    self.bottomSpaceConstraint.constant = 0;
    [self configureView];
}

//////////////////////////////////////////////////////////////////////////////////////////
// Keyboard Mgmt
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session.managedObjectContext save:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardFrameChanged:(NSNotification*)note
{
    NSTimeInterval animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect kbFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbFrame = [self.view.window convertRect:kbFrame toView:self.view];
    CGFloat distanceFromBottom = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(kbFrame);
    self.bottomSpaceConstraint.constant = distanceFromBottom;
    // Animate the change
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if ([note.name isEqualToString:UIKeyboardWillShowNotification])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
 
}
//////////////////////////////////////////////////////////////////////////////////////////


- (void)setSession:(Session *)session
{
    _session = session;
    [self configureView];
}

- (void)configureView
{
    self.dateField.text = self.session.dateString;
    self.subjectField.text = self.session.subject;
    self.summaryField.text = self.session.summary;
    [self.cityButton setTitle:self.session.city.name forState:UIControlStateNormal];
    NSString* lecturerName = self.session.lecturer.fullname ?: @"Inconnu";
    [self.lecturerButton setTitle:lecturerName forState:UIControlStateNormal];
  
    // List all sessions with similar subject
    [self fillSimilarSessionsList];
    [(UIDatePicker*)self.dateField.inputView setDate:self.session.date];
}

- (void)fillSimilarSessionsList
{
    NSArray* foundSessions = [self findSimilarSessions];
    if (foundSessions.count == 0)
    {
        self.similarSessionsField.text = @"No session found";
    }
    else
    {
        self.similarSessionsField.text = [[foundSessions valueForKey:@"shortDescription"] componentsJoinedByString:@",\n"];
    }
}

///////////////////////////////////////////////////////////////////////////////////////


_BOOKMARK_
- (NSArray*)findSimilarSessions
{
    NSManagedObjectContext* moc = self.session.managedObjectContext;
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subject CONTAINS[c] %@ AND self != %@", self.session.subject, self.session];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    return [self.session.managedObjectContext executeFetchRequest:request error:nil];
}




///////////////////////////////////////////////////////////////////////////////////////

- (void)dateChanged:(UIDatePicker*)sender
{
    self.session.date = sender.date;
    self.dateField.text = self.session.dateString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (textField != self.dateField); // Must not type text in the date field
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.subjectField)
    {
        self.session.subject = textField.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.session.summary = textView.text;
}

- (IBAction)editCity:(id)sender
{
    // TODO: Show VC to choose or add city
    [self dismissKeyboard];
}

- (IBAction)editLecturer:(id)sender
{
    // TODO: Show VC to choose or add lecturer
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.dateField resignFirstResponder];
    [self.subjectField resignFirstResponder];
    [self.summaryField resignFirstResponder];
}

@end
