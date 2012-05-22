//
//  ContactViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "ContactGridViewController.h"
#import "NSMutableArray+ContactViewController.h"
#import "SingleContactViewController.h"
#import "ContactGridViewController+TranslateAndPulseContactViewController.h"
#import "ContactGridViewController+RotateSingleViewController.h"
#import "UIView+Fading.h"
#import "UIView+Pulse.h"


@implementation ContactGridViewController
@synthesize testArray;
@synthesize dismissViewButton;


#pragma mark - Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.testArray = [[NSMutableArray alloc] initWithCapacity:0];
    contactsViewControllerAreOnFinalPosition = NO;
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Contacts stacks display and undisplay management

/**
 @brief Add the contacts to a stack of contacts and then dispatch them on the view.
 @author : Rémi Lavedrine
 @date : 10/04/2012
 @remarks : (facultatif)
 */
- (void)displayContactsView:(CGPoint)touchOrigin{
  /**
   [self addContactViewControllersToView];
   [self revealContactViewControllersThroughRotation];
   */
  thumbnailImageViewLocationOnWindow = touchOrigin;
  [self createContactsStack];
  [self performSelector:@selector(moveAllContactViewControllerToFinalPosition) withObject:nil afterDelay:(SUPERVIEW_FADEOUT_DURATION + ADD_SUBVIEW_DELAY * [self.testArray count])];
  
}

/**
 @brief Regroup the contacts to a stack of contacts and then remove them from the view.
 @author : Rémi Lavedrine
 @date : 10/04/2012
 @remarks : (facultatif)
 */
- (void)undisplayContactsView{
  /**
   [self hideContactViewControllersThroughRotation];
   */
  [dismissViewButton pulseDuringTimeInterval:cellPulseDuration];
  [self moveAllContactViewControllerToInitialPosition];
  [self performSelector:@selector(removeContactsStacks) withObject:nil afterDelay:0.3 + (DELAY * [self.testArray count])];
  
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeViewTroughNotif:) name:kRemoveContactSelectionOnEventKey object:nil];
  
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  
  [self setDismissViewButton:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  [self setTestArray:nil];
}

- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kRemoveContactSelectionOnEventKey object:nil];
  
  [self setTestArray:nil];
  [self setDismissViewButton:nil];
  [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (IBAction)removeView{
  [self undisplayContactsView];
  double removeContactViewsDuration = (TRANSLATION_DELAY + (DELAY * [self.testArray count]) + (REMOVE_SUBVIEW_DELAY * [self.testArray count]));
  [self.view performSelector:@selector(fadeInDuring:) withObject:[NSNumber numberWithDouble:SUPERVIEW_FADEOUT_DURATION] afterDelay:0];
  [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:(removeContactViewsDuration)];
}

- (IBAction)removeViewTroughNotif:(NSNotification *)notification{
  [self removeView];
}


#pragma mark -
#pragma mark Accessors

- (void)setContactArray:(NSArray *)contactArray{
  self.testArray = [[contactArray copy] autorelease];
}

@end
