
//
//  EventViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventViewController.h"
#import "MOContact.h"
#import "PeopleTableViewCell.h"
#import "GestionBudgetAppDelegate.h"
#import "AddExpenseViewController.h"
#import "MOExpense.h"
#import "UIView+Pulse.h"
#import "NSMutableArray+ContactViewController.h"


@interface EventViewController () {
  
  MOEvent *event_;
  MOContact *currentContact_;
  
  NSString *expenseTotalNumber_;
  NSString *expenseTotalAmount_;
}

@property (nonatomic, retain) MOEvent *event_;
@property (nonatomic, retain) MOContact *currentContact_;


@property (nonatomic, retain) NSString *expenseTotalNumber_;
@property (nonatomic, retain) NSString *expenseTotalAmount_;

@end

@implementation EventViewController
@synthesize fetchedResultsController = fetchedResultsController_;
@synthesize event_;
@synthesize currentContact_;
@synthesize expenseTotalNumber_;
@synthesize expenseTotalAmount_;


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(MOEvent *)event{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.event_ = event;
    /**
     NSMutableArray *contacts = [[NSMutableArray arrayWithArray:[self.event_.ParticipatingContacts allObjects]] orderContactArrayByFirstName];
     if ( [contacts count] > 0) {
     self.currentContact_ = [contacts objectAtIndex:0];
     }else{
     self.currentContact_ = nil;
     }
     */
    self.currentContact_ = [[NSMutableArray arrayWithArray:[self.event_.ParticipatingContacts allObjects]] firstContactFromEventAscending];
    
    self.expenseTotalNumber_ = @"";
    self.expenseTotalAmount_ = @"";
  }
  
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.expenseTotalNumber_ = @"";
    self.expenseTotalAmount_ = @"";
  }
  
  return self;
}


#pragma mark -
#pragma mark Navigation Controller selector management

- (void)createSegmentedControl{
  NSArray *segControlItems = [NSArray arrayWithObjects:[UIImage imageNamed:@"Bar_chart_icon.png"], [UIImage imageNamed:@"Pie_chart_icon.png"], @"Contact", nil];
	UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:segControlItems];
	segControl.segmentedControlStyle = UISegmentedControlStyleBar;
	// [segControl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
  [segControl setSelectedSegmentIndex:2];
  
  [[self navigationItem] setTitleView:segControl];
  
	[segControl release];
}

- (void)changeBackButtonItem{
  RLLogDebug(@"Changement du backTitle");
  UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Les évènements" style:UIBarButtonItemStyleBordered target:nil action:nil];
  
  [[self navigationItem] setBackBarButtonItem:newBackButton];
  
  [newBackButton release];
}


#pragma mark -
#pragma mark Notification registration management

- (void)registerToCurrentContactChangeRequest{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewForContact:) name:kSelectNewContactForEvent object:nil];
}

- (void)unregisterToCurrentContactChangeRequest{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kSelectNewContactForEvent object:nil];
}

- (void)registerToExpenseAdding{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFirstCell) name:@"ExpenseAdded" object:nil];
}

- (void)unregisterToExpenseAdding{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ExpenseAdded" object:nil];
}


#pragma mark -
#pragma Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if ( indexPath.section == 0 ) {
    return 180;
  }else if ( indexPath.section == 1 ) {
    return 44;
  }
  
  return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if ( section == 1) {
    return 25;
  }
  
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  if (section == 1) {
    return @"Les dépenses";
  }
  
  return @"";
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  switch (section) {
    case 0:
      return 1;
      break;
    case 1:
      return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
      break;
      
    case 2:
      return 1;
      break;
      
    default:
      return 0;
      break;
  }
  
  return 0;
}

- (int)getAllExpenseAmountForUser{
  int allAmount = 0;
  for (MOExpense *expense in [self.fetchedResultsController fetchedObjects] ) {
    allAmount = allAmount + [[expense Amount] intValue];
  }
  
  return allAmount;
}


/**
 @brief Set the the expense part info to be displayed on the cell.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)setFirstCellInfo{
  int numberOfExpense = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
  self.expenseTotalNumber_ = [NSString stringWithFormat:@"%d", numberOfExpense];
  self.expenseTotalAmount_ = [NSString stringWithFormat:@"%d €", [self getAllExpenseAmountForUser]];
}

/**
 @brief Set all the info needed to be displayed on the cell and register to handle long press gesture on the contact thumbnail image and to the contact change action..
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)setContactInfoCell:(PeopleTableViewCell *)cell{
  [cell setFirstAndLastNameLabelText:[NSString stringWithFormat:@"%@ %@", self.currentContact_.FirstName, self.currentContact_.LastName]];
  [self setFirstCellInfo];
  [cell setNumberOfExpensesLabelText:self.expenseTotalNumber_];
  [cell setAmountOfExpensesLabelText:self.expenseTotalAmount_];
  
  NSData *thumbnailData = [self.currentContact_ ThumbnailImage];
  UIImage *image = [[UIImage alloc] initWithData:thumbnailData];
  [cell setThumbnailImage:image];
  [image release];
  
  [cell setEvent:self.event_];
  [cell setContact:self.currentContact_];
  
  [cell addLongPressGestureRecognizer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView peopleCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *CellIdentifier = @"PeopleTableViewCell";
  
  PeopleTableViewCell *cell = (PeopleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
    cell = (PeopleTableViewCell *)[topLevelObjects objectAtIndex:0];
  }
  [self setContactInfoCell:cell];
  
  return cell;
}  

- (UITableViewCell *)tableView:(UITableView *)tableView expenseCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *CellIdentifier = @"ExpenseCell";
  NSIndexPath *correctIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
  MOExpense *expense = [self.fetchedResultsController objectAtIndexPath:correctIndexPath];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  }
  
  // Configure the cell...
  [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %d€", [expense Name], [[expense Amount] intValue]]];
  [cell.detailTextLabel setText:[expense Description]];
  [cell.imageView setImage:[UIImage imageNamed:@"coins.png"]];
  
  RLLogDebug(@"[EventViewController::expenseCellForRowAtIndexPath] %@ %@", [[expense Owner] FirstName], [[expense Owner] LastName]);
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView addExpenseCellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *MyIdentifier = @"AddExpenseTableViewCell";
	
  UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil){
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier] autorelease];
	}
  // [cell.textLabel setText:@"On ajoute un évènement"];
  UIImageView *addExpenseImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addEventPlus.png"]] autorelease];
  [addExpenseImageView setFrame:CGRectMake(320/2 - 64/2, 30, 64, 64)];
  [cell.contentView addSubview:addExpenseImageView];
  
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [cell.selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
  
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.section == 0 ) {
    return [self tableView:self.tableView peopleCellForRowAtIndexPath:indexPath];
  }else if ( indexPath.section == 1 ) {
    return [self tableView:self.tableView expenseCellForRowAtIndexPath:indexPath];
  }else{
    return [self tableView:self.tableView addExpenseCellForRowAtIndexPath:indexPath];
  }
}


#pragma mark - 
#pragma mark Table view delegate

/**
 @brief Display the Controller which allows the user to add an expense.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)displayAddExpenseViewController{
  AddExpenseViewController *addExpenseViewController = [[AddExpenseViewController alloc] initWithNibName:@"AddExpenseViewController" bundle:nil event:self.event_ contact:self.currentContact_];
  // ...
  // Pass the selected object to the new view controller.
  [self.navigationController presentModalViewController:addExpenseViewController animated:YES];
  [addExpenseViewController release];
}

/**
 @brief Pulse the "+" cell and then display the Controller which allows the user to add an expense.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
#define CELL_PULSE_DURATION 0.1
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  if ( indexPath.section == 2 ) {
    // 1. Pulse the cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell pulseDuring:[NSNumber numberWithDouble:CELL_PULSE_DURATION]];
    
    // 2. Display the desired ViewController.
    [self performSelector:@selector(displayAddExpenseViewController) withObject:nil afterDelay:CELL_PULSE_DURATION];
  }
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
  
  [self setFirstCellInfo];
  
  [self registerToCurrentContactChangeRequest];
  [self registerToExpenseAdding];
  // self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  [self createSegmentedControl];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.event_ = nil;
  self.currentContact_ = nil;
  self.expenseTotalAmount_ = nil;
  self.expenseTotalNumber_ = nil;
  
  fetchedResultsController_ = nil;
  self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Reload view component management

- (void)reloadFirstCell{
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadViewForContact:(NSNotification *)notification{
  self.currentContact_ = [notification object];
  fetchedResultsController_ = nil;
  NSError *error;
  if (![[self fetchedResultsController] performFetch:&error]) {
    // Update to handle the error appropriately.
    exit(-1);  // Fail
  }
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{  
  [self setFetchedResultsController:nil];
  self.event_ = nil;
  self.currentContact_ = nil;
  self.expenseTotalAmount_ = nil;
  self.expenseTotalNumber_ = nil;
  
  fetchedResultsController_ = nil;
  self.fetchedResultsController = nil;
  
  [self unregisterToCurrentContactChangeRequest];
  [self unregisterToExpenseAdding];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
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
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeMove:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
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
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1], nil] withRowAnimation:UITableViewRowAnimationBottom];
      // [self setFirstCellInfo];
      // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1], nil] withRowAnimation:UITableViewRowAnimationBottom];
      [self setFirstCellInfo];
      // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1], nil] withRowAnimation:UITableViewRowAnimationBottom];
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1], nil] withRowAnimation:UITableViewRowAnimationBottom];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:newIndexPath.row inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
      // [self setFirstCellInfo];
      // [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
  [self.tableView endUpdates];
}


#pragma mark -
#pragma mark NSFetchedRequest management

- (NSFetchedResultsController*)fetchedResultsController {
  
  if (fetchedResultsController_ != nil) {
    return fetchedResultsController_;
  }
  
  NSManagedObjectContext *context = [(GestionBudgetAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"MOExpense" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"CreationDate" ascending:NO];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  RLLogDebug(@"[EventViewController::fetchedResultsController] %@", self.currentContact_.FirstName);
  // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY Owner.FirstName == %@) AND (ANY EventOwner.Name == %@) AND (ANY EventOwner.CreationDate == %@)", currentContact_.FirstName, event_.Name, event_.CreationDate];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Owner.FirstName == %@) AND (EventOwner.Name == %@) AND (EventOwner.CreationDate == %@)", self.currentContact_.FirstName, self.event_.Name, self.event_.CreationDate];
  [fetchRequest setPredicate:predicate];
  
  
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

@end
