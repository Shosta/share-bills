//
//  AddExpenseViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "AddExpenseOperation.h"


@implementation AddExpenseViewController

@synthesize expenseNameTextField;
@synthesize expenseDescriptionTextField;
@synthesize expenseAmountTextField;


#pragma mark -
#pragma mark Action management

- (IBAction)saveAndDismissView{
  NSString *expenseName = [[NSString alloc] initWithString:expenseNameTextField.text];
  NSString *expenseDescription = [[NSString alloc] initWithString:expenseDescriptionTextField.text];
  NSString *expenseAmount = [[NSString alloc] initWithString:expenseAmountTextField.text];
  
  AddExpenseOperation *addExpenseOperation = [[AddExpenseOperation alloc] initWithExpenseName:expenseName Description:expenseDescription Amount:[expenseAmount intValue] Event:event_ Contact:contact_];
  [addExpenseOperation start];
  [addExpenseOperation release];
  
  [expenseName release];
  [expenseDescription release];
  [expenseAmount release];
  
  
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction{
  [self dismissModalViewControllerAnimated:YES];  
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(MOEvent *)event contact:(MOContact *)contact
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    event_ = [event retain];
    contact_ = [contact retain];
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [event_ release];
  [contact_ release];
  
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
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.expenseNameTextField = nil;
  self.expenseDescriptionTextField = nil;
  self.expenseAmountTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
