//
//  EventsViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventTableViewCell.h"
#import "GestionBudgetAppDelegate.h"
#import "AddEventViewController.h"
#import "MOEvent.h"
#import "MOContact.h"
#import "PageContainerViewController.h"
#import "Page.h"
#import "EventViewController.h"
#import "EventCellPageContainerModel.h"
#import "UIView+Pulse.h"

@implementation EventsTableViewController

@synthesize tableView;
@synthesize fetchedResultsController = fetchedResultsController_;


#pragma mark -
#pragma mark Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type{
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeMove:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController*)controller 
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath*)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath*)newIndexPath {
  
  switch (type) {
      
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
  [self.tableView endUpdates];
}


#pragma mark -
#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    return 235;
  }else{
    return 150;
  }
}

/**
 @brief Display the Controller which allows the user to add an event.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)displayAddEventViewController{
  // RLLogDebug(@"On a selectionne la cellule d'ajout d'un evenement.");
  AddEventViewController *addEventViewController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
  [rootViewController_.navigationController presentModalViewController:addEventViewController animated:YES];
  [addEventViewController release];
}

/**
 @brief Display the selected event.
 Or pulse the "+" cell and then display the Controller which allows the user to add an event.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
#define CELL_PULSE_DURATION 0.1
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    MOEvent *selectedEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    RLLogDebug(@"Le nombre de contact pour l'evenement %@: %d", [selectedEvent Name], [[selectedEvent ParticipatingContacts] count]);
    // RLLogDebug(@"Les contacts pour cette evenement : %@", [[selectedEvent ParticipatingContacts] description]);
    for ( MOContact *currentContact in [selectedEvent ParticipatingContacts] ) {
      RLLogDebug(@"[EventsTableViewController::didSelectRowAtIndexPath] %@ %@", [currentContact FirstName], [currentContact LastName]);
    }
    
    EventViewController *viewController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil event:selectedEvent];
    [rootViewController_.navigationController pushViewController:viewController animated:YES];
    [viewController release];
  }else{
    // 1. Pulse the cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell pulseDuring:[NSNumber numberWithDouble:CELL_PULSE_DURATION]];
    
    // 2. Display the Add Event ViewController.
    [self performSelector:@selector(displayAddEventViewController) withObject:nil afterDelay:CELL_PULSE_DURATION];
  }
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  // RLLogDebug(@"Le nombre de section dans le FetchResultController : %d", [[self.fetchedResultsController sections] count]);
  return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ( section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger eventCount = [sectionInfo numberOfObjects];
    
    // RLLogDebug(@"Le nombre d'evenement dans la section %d : %d", section, eventCount);
    return eventCount;
  }else{
    return 1;
  }
}

/**
 @brief Create a Page container from an array of contacts.
 @author : Rémi Lavedrine
 @date : 12/09/2011
 @remarks : (facultatif)
 */
- (PageContainerViewController *)createPageContainerFromContacts:(NSArray *)contacts{
  EventCellPageContainerModel *eventModel = [[[EventCellPageContainerModel alloc] initWithContactsQueue:contacts] autorelease];
  return [eventModel pageContainerViewController];
}

/**
 @brief Describe the event cell from the data source at the givent indexPath.
 @author : Rémi Lavedrine
 @date : 12/09/2011
 @remarks : (facultatif)
 */
- (UITableViewCell *)tableView:(UITableView *)tableView eventCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"EventTableViewCell";
	MOEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  EventTableViewCell *cell = (EventTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:nil options:nil];
    cell = (EventTableViewCell *)[topLevelObjects objectAtIndex:0];
  }
  
  [cell setEventNameLabelText:event.Name];
  [cell setNbParticipatingContactLabelText:[NSString stringWithFormat:@"%d participants", [(NSSet *)[event ParticipatingContacts] count]]];
  PageContainerViewController *controller = [self createPageContainerFromContacts:[(NSSet *)[event ParticipatingContacts] allObjects]];
  [cell setPageContainerViewFromController:controller];
  if ( event.EventImage ) {
    [cell setEventImage:[UIImage imageWithData:event.EventImage]];
  }else{
    [cell setEventImage:[UIImage imageNamed:@"default_event.png"]];
  }
  [cell setCreationDateLabelText:[event CreationDate]];
  [cell setLastModificationDateLabelText:[event LastModificationDate]];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView addEventCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"AddEventTableViewCell";
	
  UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
	}
  // [cell.textLabel setText:@"On ajoute un évènement"];
  UIImageView *addEventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(320/2 - 64/2, 30, 64, 64)];
  [addEventImageView setImage:[UIImage imageNamed:@"addEventPlus.png"]];
  [cell.contentView addSubview:addEventImageView];
  [addEventImageView release];
  
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [cell.selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    return [self tableView:self.tableView eventCellForRowAtIndexPath:indexPath];
  }else{
    return [self tableView:self.tableView addEventCellForRowAtIndexPath:indexPath];
  }
}


#pragma mark -
#pragma mark NSFetchedRequest management

- (NSFetchedResultsController*)fetchedResultsController {
  
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  
  NSManagedObjectContext *context = [(GestionBudgetAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"MOEvent" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"LastModificationDate" ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:context 
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
  
  self.fetchedResultsController = theFetchedResultsController;
  self.fetchedResultsController.delegate = self;
  
  [sort release];
  [fetchRequest release];
  [theFetchedResultsController release];
  
  return self.fetchedResultsController;
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    animateContactsHorizontalScroll = YES;
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [self setTableView:nil]; 
  [self setFetchedResultsController:nil];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
  RLLogDebug(@"[EventsTableViewController::didReceiveMemoryWarning] On recoit un memory warning");
}


#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  NSError *error;
  if (![[self fetchedResultsController] performFetch:&error]) {
    // Update to handle the error appropriately.
    // RLLogDebug(@"Unresolved error %@, %@", error, [error userInfo]);
    exit(-1);  // Fail
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.tableView = nil;
  rootViewController_ = nil;
  
  fetchedResultsController_ = nil;
  self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Accessors

- (void)setRootViewController:(UIViewController *)viewController{
  rootViewController_ = [[viewController retain] autorelease];
}


@end
