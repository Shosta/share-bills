//
//  AddEventViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "AddEventViewController.h"
#import "AddEventOperation.h"
#import "UIViewController+ImagePicker.h"
#import "UIView+Translation.h"
#import "UIView+Pulse.h"
#import "AlertViewManager.h"



@implementation AddEventViewController

@synthesize eventNameTextField;
@synthesize imageData;
@synthesize addEventImageButton;
@synthesize saveEventButton;


#pragma mark - TextField management

- (void)removeKeyboard{
  [self.eventNameTextField resignFirstResponder];
}

- (IBAction)displayEditEventNameUI{
  [self.view translateToX:0 Y:-230 curve:UIViewAnimationCurveEaseInOut during:0.3];
}

- (IBAction)undisplayEditEventNameUI{
  [self.view translateToX:0 Y:0 curve:UIViewAnimationCurveEaseInOut during:0.3];
  [self removeKeyboard];
}

#pragma mark -
#pragma mark Action management

- (void)displayNoEventNameAlert{
  
}

- (IBAction)saveAndDismissView{
  NSString *eventName = [[NSString alloc] initWithString:eventNameTextField.text];
  
  if ([eventName isEqualToString:@""] || !eventName ) {
    [AlertViewManager showNoEventNameAlert:self];
  }else{
    [saveEventButton pulseDuringTimeInterval:cellPulseDuration];
    
    AddEventOperation *addEventOperation = [[AddEventOperation alloc] initWithEventName:eventName eventImageData:imageData];
    [addEventOperation start];
    [addEventOperation release];
    
    [self dismissModalViewControllerAnimated:YES];
  }
 
  [eventName release];
}

- (IBAction)cancelAction{
  [self dismissModalViewControllerAnimated:YES];  
}

- (IBAction)pickUpEventImage:(id)sender{
  [self choosePhoto];
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
  self.eventNameTextField = nil;
  self.imageData = nil;
  self.addEventImageButton = nil;
  
  [saveEventButton release];
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
  self.eventNameTextField = nil;
  self.imageData = nil;
  [self setAddEventImageButton:nil];
  [self setSaveEventButton:nil];
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
