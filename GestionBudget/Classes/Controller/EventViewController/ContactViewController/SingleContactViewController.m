//
//  SingleContactViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "SingleContactViewController.h"


@implementation SingleContactViewController
@synthesize contactThumbnailImageView;
@synthesize contactNameLabel;
@synthesize currentContact;

#pragma mark - Actions

- (IBAction)selectContact:(id)sender{
  RLLogDebug(@"On a clique sur %@", currentContact.FirstName);
  [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveContactSelectionOnEventKey object:currentContact];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectNewContactForEvent object:currentContact];
}


#pragma mark - Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    [self.contactNameLabel setFrame:CGRectMake(0, 59, 100, 41)];
    [self.contactThumbnailImageView setFrame:CGRectMake(20, 0, 60, 60)];
  }
  return self;
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
  [self.view addSubview:self.contactNameLabel];
  [self.view addSubview:self.contactThumbnailImageView];
}

- (void)viewDidUnload
{
  [self setContactThumbnailImageView:nil];
  [self setContactNameLabel:nil];
  [self setCurrentContact:nil];
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [self setContactThumbnailImageView:nil];
  [self setContactNameLabel:nil];
  [self setCurrentContact:nil]; 
  
  [super dealloc];
}


#pragma mark - Accessors

- (void)defineUI{
  [self.contactThumbnailImageView setImage:[UIImage imageWithData:currentContact.ThumbnailImage]];
  [self.contactNameLabel setText:currentContact.FirstName];
}

- (void)setContactThumbnailImage:(UIImage *)image{
  [self.contactThumbnailImageView setImage:image];
}

- (void)setContactNameLabelText:(NSString *)text{
  [self.contactNameLabel setText:text];
}

@end
