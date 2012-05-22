//
//  PeopleSelectionViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PeopleSelectionViewController.h"
#import "PeopleSelectionTableViewCell.h"
#import "People.h"
#import "PeopleOperation.h"
#import "MOContact.h"
#import "GestionBudgetAppDelegate.h"
#import "OLTableViewSectionSwitcherViewController.h"


@implementation PeopleSelectionViewController

@synthesize fetchedResultsController = fetchedResultsController_;


#pragma mark -
#pragma mark Table populating management

-(void)insertContactAtIndexPathsOnMainThread:(NSArray *)newIndexPaths{
  // NSLog(@"On fait la mise à jour à l'index (insert) : %@", [newIndexPaths description]);
  [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)deleteContactAtIndexPathsOnMainThread:(NSArray *)newIndexPaths{
  // NSLog(@"On fait la mise à jour à l'index (delete) : %@", [newIndexPaths description]);
  [self.tableView deleteRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)moveContactOnMainThreadFromIndexPaths:(NSArray *)oldIndexPaths AtIndexPaths:(NSArray *)newIndexPaths{
  [self.tableView deleteRowsAtIndexPaths:oldIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
  [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
}


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
      [self performSelectorOnMainThread:@selector(insertContactAtIndexPathsOnMainThread:) withObject:[NSArray arrayWithObject:newIndexPath] waitUntilDone:YES];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self performSelectorOnMainThread:@selector(deleteContactAtIndexPathsOnMainThread:) withObject:[NSArray arrayWithObject:newIndexPath] waitUntilDone:YES];
      break;
      
    case NSFetchedResultsChangeMove:
      [self performSelectorOnMainThread:@selector(deleteContactAtIndexPathsOnMainThread:) withObject:[NSArray arrayWithObject:newIndexPath] waitUntilDone:YES];
      [self performSelectorOnMainThread:@selector(insertContactAtIndexPathsOnMainThread:) withObject:[NSArray arrayWithObject:newIndexPath] waitUntilDone:YES];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
  [self.tableView endUpdates];
}


#pragma mark -
#pragma mark Selection Panel management

- (void)displaySelectionPanel{
  // NSLog(@"On affiche le selection Panel");
  OLTableViewSectionSwitcherViewController *switcherViewController = [[OLTableViewSectionSwitcherViewController alloc] initWithNibName:@"OLTableViewSectionSwitcherViewController" bundle:nil rootTableViewController:self];
  [switcherViewController.view setFrame:CGRectMake(0, 20, 320, 460)];
  [self.view.window addSubview:switcherViewController.view];
  [self.view.window bringSubviewToFront:switcherViewController.view];
}


#pragma mark -
#pragma mark TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  // NSLog(@"Le nombre de section dans le FetchResultController : %d", [[self.fetchedResultsController sections] count]);
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  NSInteger contactCount = [sectionInfo numberOfObjects];
  
  if (contactCount == 0) {
    
  } else {
    
  }
  
  // NSLog(@"Le nombre de contact dans la section %d : %d", section, contactCount);
  return contactCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"PeopleSelectionTableViewCell";
	
  PeopleSelectionTableViewCell *cell = (PeopleSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:MyIdentifier owner:nil options:nil];
    cell = (PeopleSelectionTableViewCell *)[topLevelObjects objectAtIndex:0];
    [cell addLongPressGestureRecognizer];
	}
  
  MOContact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell setPeopleFirstNameLabelText:[contact FirstName]];
  [cell setPeopleLastNameLabelText:[contact LastName]];
  [cell setPeopleThumbnail:[UIImage imageWithData:[contact ThumbnailImage]]];
  // NSLog(@"On decrit la cellule : %@ : %@", indexPath, [contact description]);

  return cell;
}


#pragma mark -
#pragma mark Table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  NSString *headerTitle = @"-";
  
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  NSInteger contactCount = [sectionInfo numberOfObjects];
  
  if (contactCount != 0) {
    MOContact *contact = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    headerTitle = [contact FirstChar];
  }
  
  UIButton *headerClickable = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
  [headerClickable setTitle:headerTitle forState:UIControlStateNormal];
  [headerClickable setBackgroundColor:[UIColor orangeColor]];
  [headerClickable setAlpha:0.75];
  [headerClickable addTarget:self action:@selector(displaySelectionPanel) forControlEvents:UIControlEventTouchUpInside];
  
  return [headerClickable autorelease];
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
 NSInteger contactCount = [sectionInfo numberOfObjects];
 
 if (contactCount != 0) {
 MOContact *contact = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
 
 return [contact FirstChar];
 }
 
 return @"-";
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  // NSLog(@"On selectionne la cellule : %@ : %@", indexPath, [[self.fetchedResultsController objectAtIndexPath:indexPath] description]);
}


#pragma mark -
#pragma mark NSFetchedRequest management

- (NSFetchedResultsController*)fetchedResultsController {
  
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  
  // NSLog(@"On realise le fetch sur CoreData pour les contacts");
  NSManagedObjectContext *context = [(GestionBudgetAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"MOContact" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"FirstName" ascending:YES];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  [fetchRequest setFetchBatchSize:5];
  
  NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:context 
                                                                                                  sectionNameKeyPath:@"FirstChar"
                                                                                                           cacheName:nil];
  
  self.fetchedResultsController = theFetchedResultsController;
  self.fetchedResultsController.delegate = self;
  
  [sort release];
  [fetchRequest release];
  [theFetchedResultsController release];
  
  return self.fetchedResultsController;
}


#pragma mark - 
#pragma mark View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
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


#pragma mark -
#pragma mark Memory management

/**
 Insert the contact to the tableView
 @author : Rémi Lavedrine
 @date : 08/09/2011
 @remarks : The |notification| object is the indexPath of the contact in the |contactList_| object.
 */
-(void)insertContactAtIndexPath:(NSNotification *)notification{
  [self performSelectorOnMainThread:@selector(insertContactAtIndexPathOnMainThread:) withObject:notification waitUntilDone:YES];
}

- (void)getDataModelIfNeeded{
  if ( [[self.fetchedResultsController fetchedObjects] count] == 0 ) {
    PeopleOperation *peopleOperation = [[PeopleOperation alloc] init];
    [peopleOperation start];
    [peopleOperation release];
  }
}

- (void)dealloc
{
  [self.fetchedResultsController release];
  [fetchedResultsController_ release];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
      // Update to handle the error appropriately.
      // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      exit(-1);  // Fail
    }
  }
  
  return self;
}

@end
