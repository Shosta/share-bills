//
//  EventsViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventsViewController.h"
#import "EventTableViewCell.h"
#import "GestionBudgetAppDelegate.h"
#import "AddEventViewController.h"
#import "MOEvent.h"

#import "MOContact.h"


#import "PageContainerViewController.h"
#import "Page.h"

@implementation EventsViewController

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    MOEvent *selectedEvent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"Le nombre de contact pour l'evenement %@: %d", [selectedEvent Name], [[selectedEvent ParticipatingContacts] count]);
    // NSLog(@"Les contacts pour cette evenement : %@", [[selectedEvent ParticipatingContacts] description]);
    for ( MOContact *currentContact in [selectedEvent ParticipatingContacts] ) {
      NSLog(@"%@ %@", [currentContact FirstName], [currentContact LastName]);
    }
  }else{
    // NSLog(@"On a selectionne la cellule d'ajout d'un evenement.");
    AddEventViewController *addEventViewController = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
    [self presentModalViewController:addEventViewController animated:YES];
    [addEventViewController release];
  }
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  // NSLog(@"Le nombre de section dans le FetchResultController : %d", [[self.fetchedResultsController sections] count]);
  return [[self.fetchedResultsController sections] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if ( section == 0 && [[self.fetchedResultsController sections] count] != 0 ) {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger eventCount = [sectionInfo numberOfObjects];
    
    if (eventCount == 0) {
      
    } else {
      
    }
    
    // NSLog(@"Le nombre d'evenement dans la section %d : %d", section, eventCount);
    return eventCount;
  }else{
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView eventCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"EventTableViewCell";
	
  EventTableViewCell *cell = (EventTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:nil options:nil];
    cell = (EventTableViewCell *)[topLevelObjects objectAtIndex:0];
	}
  
  MOEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell setEventNameLabelText:event.Name];
  [cell setNbParticipatingContactLabelText:[NSString stringWithFormat:@"%d participants", [(NSSet *)[event ParticipatingContacts] count]]];
  [cell setContacts:[(NSSet *)[event ParticipatingContacts] allObjects]];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView addEventCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"AddEventTableViewCell";
	
  UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:MyIdentifier] autorelease];
	}
  // [cell.textLabel setText:@"On ajoute un évènement"];
  UIImageView *addEventImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addEventPlus.png"]] autorelease];
  [addEventImageView setFrame:CGRectMake(320/2 - 64/2, 30, 64, 64)];
  [cell.contentView addSubview:addEventImageView];
  // [addEventImageView release];
  
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
  [fetchRequest setFetchBatchSize:12];
  
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
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
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
    // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    exit(-1);  // Fail
  }
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
