//
//  GestionBudgetViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "GestionBudgetViewController.h"
#import "EventsTableViewController.h"
#import "MOEvent.h"
#import "MOContact.h"
#import "DataModelSavingManager.h"
#import "OLStatusView.h"
#import "GestionBudgetAppDelegate.h"
#import "CoreDataHelper.h"
#import "UIViewController+StatusView.h"
#import "EventTableViewCell.h"

@interface GestionBudgetViewController () {
  
  BOOL lowerViewHidden;
}

@end

@implementation GestionBudgetViewController
@synthesize displayLowerViewBarButtonItem;
@synthesize modifiedTableViewBarButtonItem;


#pragma mark -
#pragma mark Status view management

/**
 @brief Display a status to tell the user that the contac has been correctly added to the event.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
/* - (void)displayStatusViewForContactAddition:(MOContact *)contact onEvent:(MOEvent *)event{
  // NSString *p  = [NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]];
  OLStatusView *statusView = [[OLStatusView alloc] initWithStatusLabel:[NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]] 
                                                              textFont:[UIFont fontWithName:@"Helvetica" size:16] 
                                                           orientation:UIInterfaceOrientationPortrait 
                                                  translationDirection:DownToUp];
  statusView.delegate = self;
  [statusView animateShowOnView:self.view.window];
  [statusView performSelector:@selector(animateRemove) withObject:nil afterDelay:2];
  [statusView release];
} */

/**
 @brief Display a status to tell the user that the contac has been correctly added to the event from a notification.
 @author : Rémi Lavedrine
 @date : 30/03/2012
 @remarks : (facultatif)
 */
/* - (void)displayStatusViewForContactAddition:(NSNotification *)notification{
  NSDictionary *dict = [notification object];
  MOContact *contact = [dict objectForKey:kContactKey];
  MOEvent *event = [dict objectForKey:kEventKey];
  
  [self displayStatusViewForContactAddition:contact onEvent:event];
}*/ 


#pragma mark -
#pragma mark Adding contact management

- (CGPoint)getLocationOnTableView:(UITableView *)tableView fromLocationOnWindow:(CGPoint)locationOnWindow{
  CGPoint locationOnTableView = CGPointMake(locationOnWindow.x, locationOnWindow.y + tableView.contentOffset.y);
  
  return locationOnTableView;
}

/**
 @brief Get an event from its location on the tableView.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
- (MOEvent *)getEventFromLocationOnView:(CGPoint)location{
  // We get the indexPath of the cell wich has this location on the tableView.
  UITableView *eventTableView = [(EventsTableViewController *)[self upperViewController] tableView];
  NSArray *indexPathsForVisibleRows = [eventTableView indexPathsForVisibleRows];
  for (NSIndexPath *currentIndexPath in indexPathsForVisibleRows) {
    CGRect cellRect = [eventTableView rectForRowAtIndexPath:currentIndexPath];
    RLLogDebug(@"currentIndexPath : %@; %f; %f; %f; %f", [currentIndexPath description], cellRect.origin.x, cellRect.origin.y, cellRect.size.width, cellRect.size.height);
  }
  
  CGPoint locationOnTableView = [self getLocationOnTableView:eventTableView fromLocationOnWindow:location];
  RLLogDebug(@"La localisation sur la tableView : %f; %f", locationOnTableView.x, locationOnTableView.y);
  NSIndexPath *cellIndexPath = [[(EventsTableViewController *)[self upperViewController] tableView] indexPathForRowAtPoint:locationOnTableView];
  if ( [cellIndexPath section] > [[[(EventsTableViewController *)[self upperViewController] fetchedResultsController] sections] count] - 1 || cellIndexPath == nil) {
    return nil;
  }else{
    // We get the corresponding event in the data model from this indexPath.
    MOEvent *event = [[(EventsTableViewController *)[self upperViewController] fetchedResultsController] objectAtIndexPath:cellIndexPath];
    return event;
  }
  
  return nil;
}

- (MOContact *)getContactFromIndexPath:(NSIndexPath *)indexPath{
  // We get the corresponding Contact from the indexPath.
  MOContact *contact = [[peopleSelectionViewController fetchedResultsController] objectAtIndexPath:indexPath];
  
  return contact;
}

- (void)updateEventLastModificationDate:(MOEvent *)event{
  [event setLastModificationDate:[NSDate date]];
}

- (void)scrollTableViewToEventNewLocationOnTableView{
  [[(EventsTableViewController *)[self upperViewController] tableView] reloadData];
  
  [[(EventsTableViewController *)[self upperViewController] tableView] scrollsToTop];
}

/**
 @brief Add a contact to the event described on the |y| location given from the |notification| object.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : The |notification| object is a NSDictionary with two Objects and two keys
 NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cellCurrentIndexPath_, [recognizer locationInView:self.window].y, nil]
 forKeys:[NSArray arrayWithObjects:@"CellIndexPathOnSelectionContactList", @"LocationOnEventsView", nil]];
 */
- (void)updateEvent:(NSNotification *)notification{
  NSDictionary *dict = [notification object];
  RLLogDebug(@"Dict desc : %@", [dict description]);
  
  // MOEvent *correspondingEvent = [self getEventFromLocationOnView:CGPointMake([revealWidthNumber floatValue] + 50, [[dict objectForKey:@"LocationOnEventsView"] floatValue])];
  MOEvent *correspondingEvent = [self getEventFromLocationOnView:CGPointMake([self revealWidth], [[dict objectForKey:@"LocationOnEventsView"] floatValue])];
  RLLogDebug(@"L'evenement correspondant dans lequel il faut ajouter le contact : %@", [correspondingEvent description]);
  
  MOContact *correspondingContact = [[peopleSelectionViewController fetchedResultsController] objectAtIndexPath:[dict objectForKey:@"CellIndexPathOnSelectionContactList"]];
  RLLogDebug(@"Le contact correspondant : %@", [correspondingContact description]);
  
  if ( correspondingEvent ) { // If there is no event, don't add the contact to it.
    // Add the new contact to the event
    [CoreDataHelper addNewContact:correspondingContact toEvent:correspondingEvent];
    
    // Change the last modification date.
    [self updateEventLastModificationDate:correspondingEvent];
    
    // Save the DataModel
    [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
    
    // [self displayStatusViewForContactAddition:correspondingContact onEvent:correspondingEvent];
    
    [self scrollTableViewToEventNewLocationOnTableView];
  }
}


#pragma mark -
#pragma Notification management

- (void)registerToNotification{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEvent:) name:kAddContactToEventNotificationKey object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayStatusViewForContactAddition:) name:kDisplayContactAdditionNotificationKey object:nil];
  
}

- (void)unregisteredToNotification{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddContactToEventNotificationKey object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kDisplayContactAdditionNotificationKey object:nil];
}


#pragma mark -
#pragma mark LowerView creation

- (void)createLowerViewIfNil{
  if ( peopleSelectionViewController == nil ) {
    RLLogDebug(@"Lower view is Nil, we create it");
    peopleSelectionViewController = [[PeopleSelectionViewController alloc] initWithNibName:@"PeopleSelectionViewController" bundle:nil];
  }
}


#pragma mark -
#pragma mark Firing actions at the beginning and end of the upper view scrolling

- (void)lowerViewWillAppear{
  [self registerToNotification];
  
  [self createLowerViewIfNil];
  // Do any actions before the upper view start being revealed.
  [peopleSelectionViewController getDataModelIfNeeded];
  [self.view addSubview:peopleSelectionViewController.tableView];
  [self.view sendSubviewToBack:peopleSelectionViewController.tableView];
  //  [peopleSelectionViewController.tableView setFrame:CGRectMake(0, 0, [revealWidthNumber intValue], 416)];
  [peopleSelectionViewController.tableView setFrame:CGRectMake(0, 0, [self revealWidth], 416)];
  RLLogDebug(@"TableView size : %f; %f", peopleSelectionViewController.tableView.frame.size.width, peopleSelectionViewController.tableView.frame.size.height);
  [peopleSelectionViewController.tableView setBackgroundColor:[UIColor clearColor]];
}

- (void) lowerViewDidAppear{
  // Do any actions while the upper view start has been revealed.
  self.title = @"Choisissez vos contacts";
}

- (void)lowerViewWillDisappear{
  // Do any actions before the upper view start being hidden.
}

- (void)lowerViewDidDisappear{
  [peopleSelectionViewController.tableView removeFromSuperview];
  [self unregisteredToNotification];
  
  self.title = @"Les évènements";
  peopleSelectionViewController = nil;
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil upperViewController:(UIViewController *)viewController revealWidth:(int)revealWidth
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil upperViewController:viewController revealWidth:revealWidth];
  
  if (self) {
    lowerViewHidden = YES;
    peopleSelectionViewController = nil;
    [(EventsTableViewController *)viewController setRootViewController:self];
  }
  
  return self;
}


#pragma mark - 
#pragma mark View lifecycle

- (void)revealViewToRightWithBounce{
  self.displayLowerViewBarButtonItem.title = @"dessous";
  
  [super revealViewToRightWithBounce];
  lowerViewHidden = NO;
}

- (void)hideViewToLeftWithBounce{
  self.displayLowerViewBarButtonItem.title = @"dessus";
  
  [super hideViewToLeftWithBounce];
  lowerViewHidden = YES;
}

/**
 @brief Hide or reveal the lower depending on its current state (hide or not).
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
- (void)handleLowerViewAppearance{
  if ( lowerViewHidden ) {
    [self revealViewToRightWithBounce];
  }else{
    [self hideViewToLeftWithBounce];
  }
}

/**
 @brief Hide or reveal the buttons on each cell to allow the user to delete this event.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (void)handleTableViewModification{
  [self.modifiedTableViewBarButtonItem setTintColor:[UIColor redColor]];
  // self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
  NSArray *visibleCells = [[(EventsTableViewController *)self.upperViewController tableView] visibleCells];
  for (EventTableViewCell *cell in visibleCells) {
    [cell.deleteEventButton setHidden:NO];
  }
}

/**
 @brief Create the button bar that will be used to reveal or hide the lower view.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
- (void)createNavigationBarButtonItem{
  self.displayLowerViewBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dessus" style:UIBarButtonItemStyleBordered target:self action:@selector(handleLowerViewAppearance)];
  self.navigationItem.leftBarButtonItem = self.displayLowerViewBarButtonItem;
  
  
  self.modifiedTableViewBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"modifier" style:UIBarButtonItemStyleBordered target:self action:@selector(handleTableViewModification)];
  self.navigationItem.rightBarButtonItem = self.modifiedTableViewBarButtonItem;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"La liste des évènements";
  [self createNavigationBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  peopleSelectionViewController = nil;
  [self setDisplayLowerViewBarButtonItem:nil];
  [self setModifiedTableViewBarButtonItem:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{ 
  [peopleSelectionViewController release];
  [self setDisplayLowerViewBarButtonItem:nil];
  [self setModifiedTableViewBarButtonItem:nil];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
  RLLogDebug(@"[GestionBudgetViewController::didReceiveMemoryWarning] On recoit un memory warning");
  // [peopleSelectionViewController release];
}


@end
