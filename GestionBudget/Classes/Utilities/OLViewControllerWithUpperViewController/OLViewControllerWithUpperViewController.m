//
//  OLViewControllerWithUpperViewController.m
//  OLDraggingDemo
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "OLViewControllerWithUpperViewController.h"
#import "UIView+ShadowAddition.h"


@implementation OLViewControllerWithUpperViewController


#pragma mark -
#pragma mark Translating views

- (void)translateView:(UIView *)view toX:(float)x during:(float)seconds{
  [UIView beginAnimations:@"Animate" context:nil];
  [UIView setAnimationDuration:seconds];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  CGAffineTransform transform = CGAffineTransformMakeTranslation(x, 0);
  view.transform = transform;
  
  [UIView setAnimationDelegate:self];
  
  [UIView commitAnimations];
}


#pragma mark -
#pragma mark Reveal under view management

- (void)revealFirstPart{
  [self translateView:upperViewController_.view toX:(revealWidth_ + 30) during:0.4];
}

- (void)revealSecondPart{
  [self translateView:upperViewController_.view toX:(revealWidth_ - 5) during:0.2];
}

- (void)revealThirdPart{
  [self translateView:upperViewController_.view toX:revealWidth_ during:0.2];
}

- (void)revealViewToRightWithBounce{
  [self lowerViewWillAppear];
  [self revealFirstPart];
  [self performSelector:@selector(revealSecondPart) withObject:nil afterDelay:0.4];
	[self performSelector:@selector(revealThirdPart) withObject:nil afterDelay:0.6];
	[self performSelector:@selector(lowerViewDidAppear) withObject:nil afterDelay:0.8];
}


#pragma mark -
#pragma mark Hide under view management

- (void)hideFirstPart{
  [self translateView:upperViewController_.view toX:-30 during:0.4];
}

- (void)hideSecondPart{
  [self translateView:upperViewController_.view toX:5 during:0.2];
}

- (void)hideThirdPart{
  [self translateView:upperViewController_.view toX:0 during:0.2];
}

- (void)hideViewToLeftWithBounce{
  [self lowerViewWillDisappear];
  [self hideFirstPart];
  [self performSelector:@selector(hideSecondPart) withObject:nil afterDelay:0.4];
	[self performSelector:@selector(hideThirdPart) withObject:nil afterDelay:0.6];
  [self performSelector:@selector(lowerViewDidDisappear) withObject:nil afterDelay:0.8];
}


#pragma mark -
#pragma mark Swype gesture handling

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
    
    [self hideViewToLeftWithBounce];
    
  }
  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
    
    [self revealViewToRightWithBounce];
    
  }
  
}

/**
 @brief Add a swype gesture recognizer to the view.
 @author : Rémi Lavedrine
 @date : 01/09/2011
 @remarks : (facultatif)
 */
- (void)addSwipeGestureRecognizer{
  /*
   Create a swipe gesture recognizer to recognize right swipes (the default).
   We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
   */
	UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [upperViewController_.view addGestureRecognizer:rightRecognizer];
	[rightRecognizer release];
  
  UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [upperViewController_.view addGestureRecognizer:leftRecognizer];
  [leftRecognizer release];
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

- (void)addOuterShadowOnUpperViewIfNeeded{
  if ( YES ) {
    [[upperViewController_ view] addOuterShadow];
  }
}

- (void)addUpperViewToCurrentView{
  [self.view addSubview:[upperViewController_ view]];
  [self addOuterShadowOnUpperViewIfNeeded];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil upperViewController:(UIViewController *)viewController revealWidth:(int)revealWidth
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    // Custom initialization
    revealWidth_ = revealWidth;
    
    upperViewController_ = [viewController retain];
    [self addSwipeGestureRecognizer];
    [self addUpperViewToCurrentView];
  }
  
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [upperViewController_ release];
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
  RLLogDebug(@"[OLViewControllerWithUpperViewController::didReceiveMemoryWarning] On recoit un memory warning");
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
  upperViewController_ = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Accessors

- (UIViewController *)upperViewController{
  return upperViewController_;
}

- (int)revealWidth{
  return revealWidth_;
}

@end


@implementation OLViewControllerWithUpperViewController (ProtectedMethods)

#pragma mark -
#pragma mark Firing actions at the beginning and end of the upper view scrolling

- (void)lowerViewWillAppear{
  // Do any actions before the upper view start being revealed.
}

- (void)lowerViewDidAppear{
  // Do any actions after the upper view has been revealed.
}

- (void)lowerViewWillDisappear{
  // Do any actions before the upper view start being hidden.
}

- (void)lowerViewDidDisappear{
  // Do any actions after the upper view has been hidden.
}

@end
