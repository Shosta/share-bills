//
//  ContactsViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "ContactsViewController.h"
#import "D4MGridScrollViewCell.h"
#import "MOContact.h"

#define kNbColumns 3

@interface ContactsViewController () {
  
  NSMutableArray *testArray;
}
@property (nonatomic, retain) NSMutableArray *testArray;

@end

@implementation ContactsViewController
@synthesize gridScrollView;
@synthesize testArray;


- (IBAction)removeView{
  [self.view removeFromSuperview];
}


#pragma mark -
#pragma mark Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    gridScrollView = [[D4MGridScrollView alloc] initWithFrame:CGRectZero];
    self.gridScrollView.dataSource = self;
    self.gridScrollView.gridDelegate = self;
    
    testArray = [[NSMutableArray alloc] initWithCapacity:0];
  }
  
  return self;
}

- (void)dealloc
{
  [self setTestArray:nil];
  [self setGridScrollView:nil];
  
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
  
  [self.view addSubview:self.gridScrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
  self.gridScrollView.frame = CGRectMake(0, 65, 320, 330);
  
  [self.navigationItem setRightBarButtonItem:nil animated:animated];
  [self.gridScrollView reloadData];
  [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
  [self.gridScrollView endEditing];
  [super viewWillDisappear:animated];
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


#pragma GridScrollView dataSource

- (D4MGridScrollViewCell *)gridScrollView:(D4MGridScrollView *)scrollView cellForIndex:(NSInteger)index
{
  if ([self.testArray count] > index)
  {
    MOContact *contact = [self. testArray objectAtIndex:index];
    
    D4MGridScrollViewCell *testView = [scrollView dequeueReusableCells];
    if (nil == testView)
    {
      testView = [[[D4MGridScrollViewCell alloc] initWithFrame:CGRectZero] autorelease];
      UIImageView *thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 0, 60, 60)];
      [testView autoresizesSubviews];
      thumbnailImageView.tag = 1000;
      [testView addSubview:thumbnailImageView];
      [thumbnailImageView release];
      
      UILabel *contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 104, 44)];
      [testView autoresizesSubviews];
      contactNameLabel.tag = 2000;
      contactNameLabel.textAlignment = UITextAlignmentCenter;
      contactNameLabel.backgroundColor = [UIColor clearColor];
      contactNameLabel.textColor = [UIColor whiteColor];
      [testView addSubview:contactNameLabel];
      [contactNameLabel release];
      
    }
    
    [(UIImageView *)[testView viewWithTag:1000] setImage:[UIImage imageWithData:[contact ThumbnailImage]]];
    [(UILabel *)[testView viewWithTag:2000] setText:[contact FirstName]];
    testView.backgroundColor = [UIColor clearColor];
    
    return testView;
  }
  else return nil;
}

- (int)numberOfCellsForGridScrollView:(D4MGridScrollView *)scrollView
{
  return [self.testArray count];
}

- (int)numberOfColumnsForGridScrollView:(D4MGridScrollView *)scrollView
{
  return kNbColumns;
}

- (CGSize)cellSizeForGridScrollView:(D4MGridScrollView *)scrollView
{
  return CGSizeMake(104.0, 104.0); 
}

-(void)gridScrollView:(D4MGridScrollView *)scrollView moveCellAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
  id object = [[self.testArray objectAtIndex:fromIndex] retain];
  
  if (fromIndex > toIndex)
  {
    [self.testArray removeObjectAtIndex:fromIndex];
    [self.testArray insertObject:object atIndex:toIndex];
  }
  else
  {
    [self.testArray insertObject:object atIndex:toIndex+1];
    [self.testArray removeObjectAtIndex:fromIndex];
  }
  [object release];
}

-(void)gridScrollView:(D4MGridScrollView *)scrollView commitDeleteForItemAtIndex:(NSInteger)index
{
  [self.testArray removeObjectAtIndex:index];
  [self.gridScrollView deleteCellAtIndex:index animated:YES];
}

- (void)gridScrollViewDidBeginEdit:(D4MGridScrollView *)scrollView
{
  // D4MBarButtonItem *validateButton = [[D4MBarButtonItem alloc] initWithTitle:@"OK" target:self action:@selector(validateGridModifications)];
  // [self.navigationItem setRightBarButtonItem:validateButton animated:YES];
  // [validateButton release];
}


-(void)validateGridModifications
{
  [self.gridScrollView endEditing];
  [self.navigationItem setRightBarButtonItem:nil animated:YES];
}


#pragma GridScrollView delegate

- (void)gridScrollView:(D4MGridScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index{
  RLLogDebug(@"On a clique sur %@", [(MOContact *)[self. testArray objectAtIndex:index] FirstName]);
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectNewContactForEvent object:(MOContact *)[self. testArray objectAtIndex:index]];
  [self removeView];
}


#pragma mark -
#pragma mark Accessors

- (void)setContactArray:(NSArray *)contactArray{
  NSMutableArray *tempArray = [[[NSMutableArray alloc] initWithArray:contactArray] autorelease];
  self.testArray = tempArray;
}


@end
