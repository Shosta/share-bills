//
//  OLTableViewSectionSwitcherViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "OLTableViewSectionSwitcherViewController.h"
#import "MOContact.h"
#import "PeopleSelectionViewController.h"


@implementation OLTableViewSectionSwitcherViewController


#pragma mark -
#pragma mark Button action management

- (void)moveToSection:(id)sender{
  [self.view removeFromSuperview];
  
  // We scroll the tableView to the indexPath position.
  [rootTableViewController_.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[sender tag]] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark -
#pragma mark Buttons creation and placement

#define MAX_ROW 7
#define MAX_COLUMN 5
#define BUTTON_WIDTH 60
#define BUTTON_HEIGHT 55
#define X_PADDING 28
#define Y_PADDING 20
#define BUTTON_PADDING 6
#define COLUMN_NUMBER 4
- (int)getXButtonPositionFromColumnNumber:(int)buttonNumber{
  for (int number = MAX_COLUMN; number > 0; number--) {
    if ( (buttonNumber % number) == 0 ) {
      return X_PADDING + (number - 1) * (BUTTON_PADDING + BUTTON_WIDTH);
    }
  }
  
  return 0;
}

- (int)getYButtonPositionFromRowNumber:(int)buttonNumber{
  for (int number = MAX_ROW; number > 0; number--) {
    if ( (buttonNumber % number) == 0 ) {
      return Y_PADDING + (number - 1) * (BUTTON_PADDING + BUTTON_HEIGHT);
    }
  }
  
  return 0;
}

- (void)populateViewWithButtonFromTableViewHeader{
  int column = 1;
  int row = 1;
  int buttonNumber = 0;
  
  for (NSString *letter in lettersArray_) {
    int buttonXPosition = [self getXButtonPositionFromColumnNumber:column];
    int buttonYPosition = [self getYButtonPositionFromRowNumber:row];
    
    UIButton *switcherButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXPosition, buttonYPosition, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [switcherButton setTitle:letter forState:UIControlStateNormal];
    [switcherButton setBackgroundColor:[UIColor orangeColor]];
    [switcherButton setAlpha:0.7];
    [switcherButton setSelected:NO];
    
    for ( id<NSFetchedResultsSectionInfo> sectionInfo in [rootTableViewController_.fetchedResultsController sections] ) {
      if ( [[sectionInfo indexTitle] isEqualToString:letter] ) {
        [switcherButton setAlpha:1.0];
        [switcherButton setTag:buttonNumber];
        [switcherButton setSelected:YES];
        [switcherButton addTarget:self action:@selector(moveToSection:) forControlEvents:UIControlEventTouchUpInside];
        
        buttonNumber++;
        break;
      }
    }   
    
    [self.view addSubview:switcherButton];
    [switcherButton release];
    column++;
    if ( (column % (COLUMN_NUMBER + 1)) == 0 ) {
      column = 1;
      row++;
    }
    
  }
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootTableViewController:(PeopleSelectionViewController *)rootTableViewController
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    rootTableViewController_ = [rootTableViewController retain];
    lettersArray_ = [[NSArray alloc] initWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [rootTableViewController_ release];
  [lettersArray_ release];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self populateViewWithButtonFromTableViewHeader];
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
