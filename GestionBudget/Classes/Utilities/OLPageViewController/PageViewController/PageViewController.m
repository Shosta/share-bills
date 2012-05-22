//
//  PresentationViewController.m
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PageViewController.h"


@implementation PageViewController

@synthesize nameLabel;
@synthesize thumbnailImageView;


#pragma mark - 
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    name_ = [[NSString alloc] init];
    thumbnail_ = [[UIImage alloc] init];
    nameLabel = [[UILabel alloc] init];
    thumbnailImageView = [[UIImageView alloc] init];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}


#pragma mark -
#pragma mark Accessors

- (void)setThumbnailImage:(UIImage *)anImage{
  if ( thumbnail_ != anImage ) {
    // [thumbnail_ release];
    // thumbnail_ = [[anImage retain] autorelease];
    
    self.thumbnailImageView.image = anImage;
  }
}

- (void)setNameLabelText:(NSString *)aString{
  self.nameLabel.text = aString; 
}	


#pragma mark - 
#pragma mark Memory management

- (void)dealloc
{
  [name_ release];
  [thumbnail_ release];
  [nameLabel release];
  [thumbnailImageView release];
  
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
  /*
   [nameLabel setText:name_];
  [thumbnailImageView setImage:thumbnail_];
   */
  CGRect nameLabelRect = CGRectMake(48, 14, 82, 21);
  CGRect thumbnailImageRect = CGRectMake(10, 10, 30, 30);
  [nameLabel setFrame:nameLabelRect];
  [thumbnailImageView setFrame:thumbnailImageRect];
  [self.view addSubview:nameLabel];
  [self.view addSubview:thumbnailImageView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  // self.nameLabel = nil;
  // self.thumbnailImageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
