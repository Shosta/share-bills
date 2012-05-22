//
//  AddEventViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventOperation.h"



@implementation AddEventViewController

@synthesize eventNameTextField;


#pragma mark -
#pragma mark Action management

- (IBAction)saveAndDismissView{
  NSString *eventName = [[NSString alloc] initWithString:eventNameTextField.text];
  AddEventOperation *addEventOperation = [[AddEventOperation alloc] initWithEventName:eventName];
  [addEventOperation start];
  [addEventOperation release];
  [eventName release];
  
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelAction{
  [self dismissModalViewControllerAnimated:YES];  
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
  self.eventNameTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
