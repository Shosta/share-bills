//
//  PeopleTableViewCell.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PeopleTableViewCell.h"
#import "ContactGridViewController.h"
#import "ContactGridViewController+RotateSingleViewController.h"
#import "NSMutableArray+ContactViewController.h"
#import "UIView+Fading.h"
#import "UIView+Translation.h"
#import "DataModelSavingManager.h"

@interface PeopleTableViewCell () {
  UIImage *thumbnailImage_;
  MOEvent *event_;
  MOContact *currentContact_;
  ContactGridViewController *contactsViewController;
  NSMutableArray *eventParticipants;
  BOOL performingSwipe;
  BOOL hasRevealedLeftSide;
  BOOL hasRevealedRightSide;
}

@property (nonatomic, retain) UIImage *thumbnailImage_;
@property (nonatomic, retain) MOEvent *event_;
@property (nonatomic, retain) MOContact *currentContact_;
@property (nonatomic, retain) ContactGridViewController *contactsViewController;
@property (nonatomic, retain) NSMutableArray *eventParticipants;

@end 


@implementation PeopleTableViewCell

@synthesize eventImageView;
@synthesize thumbnailImageView;
@synthesize eventNameLabel;
@synthesize firstAndLastNameLabel;
@synthesize numberOfExpensesLabel;
@synthesize amountOfExpensesLabel;
@synthesize peopleContainerView;
@synthesize cellActionContainerView;
@synthesize removeUserContainerView;
@synthesize removeMultipleUsersContainerView;
@synthesize thumbnailImage_;
@synthesize event_;
@synthesize currentContact_;
@synthesize contactsViewController;
@synthesize eventParticipants;


#pragma mark - Handle under cell views

/**
 @brief Reveal a view under the cell by adding it to the view and then translating the peopleContainerView (the first cell) to the right.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
#define SWIPE_DURATION 0.5
- (void)revealRemoveContactView{
  performingSwipe = YES;
  [self.cellActionContainerView  addSubview:self.removeUserContainerView];
  [self.peopleContainerView translateBounceToX:280 curve:UIViewAnimationCurveEaseInOut during:SWIPE_DURATION];
  hasRevealedLeftSide = YES;
}

/**
 @brief Hide the view under the cell and then translating the peopleContainerView (the first cell) to the left to its previous position.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (void)hideRemoveContactView{
  performingSwipe = YES;
  [self.peopleContainerView translateToX:0 Y:0 curve:UIViewAnimationCurveEaseInOut during:SWIPE_DURATION];
  [self.removeUserContainerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:SWIPE_DURATION];
  hasRevealedLeftSide = NO;
}

/**
 @brief Reveal a view under the cell by adding it to the view and then translating the peopleContainerView (the first cell) to the left.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (void)revealMultipleContactsView{
  performingSwipe = YES;
  [self.cellActionContainerView  addSubview:self.removeMultipleUsersContainerView];
  [self.peopleContainerView translateBounceToX:-280 curve:UIViewAnimationCurveEaseInOut during:SWIPE_DURATION];
  hasRevealedRightSide = YES;
}

/**
 @brief Hide the view under the cell and then translating the peopleContainerView (the first cell) to the right to its previous position.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (void)hideMultipleContactsView{
  performingSwipe = YES;
  [self.peopleContainerView translateToX:0 Y:0 curve:UIViewAnimationCurveEaseInOut during:SWIPE_DURATION];
  [self.removeMultipleUsersContainerView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:SWIPE_DURATION];
  hasRevealedRightSide = NO;
}


#pragma mark - Delete contact from event

/**
 @brief Notify that the current contact has changed.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : It is done seaprately in order to perform it after a delay.
 */
- (void)notifyContactChange{
  [[NSNotificationCenter defaultCenter] postNotificationName:kSelectNewContactForEvent object:self.currentContact_];
  [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
}

/**
 @brief Delete a contact from an event.
 Hide the "Remove contact" view.
 Select the first contact from the participating contacts.
 Notify the upper view that the current contact has changed.
 Reload the TableView.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (IBAction)deleteContactFromEvent{
  RLLogDebug(@"%@; %@", [self.superview class], self.currentContact_);
  // 1. Delete a contact from an event.
  [event_ removeParticipatingContactsObject:self.currentContact_];
  
  if ( [[self.superview class] isSubclassOfClass:[UITableView class]] ) {
    // 2. Hide the "Remove contact" view.
    [self hideRemoveContactView];
    
    // 3. Select the first contact from the participating contacts.
    self.currentContact_ = [[NSMutableArray arrayWithArray:[self.event_.ParticipatingContacts allObjects]] firstContactFromEventAscending];
    
    // 4. Notify the upper view that the current contact has changed.
    [self performSelector:@selector(notifyContactChange) withObject:nil afterDelay:SWIPE_DURATION];
    
    // 5. Reload the TableView.
    // [(UITableView *)self.superview reloadData];
  }
}

#pragma mark -
#pragma mark Gesture management

/**
 @brief Display the contact grid view under the current view which contains all the contact for the current event.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)displayContactsGridView:(CGPoint)location{
  RLLogDebug(@"Display contacts gridView : %@", [self.eventParticipants description]);
  [self.contactsViewController setContactArray:self.eventParticipants];
  [self.contactsViewController.view setFrame:CGRectMake(0, 20, 320, 460)];
  [self.contactsViewController.view setAlpha:1];
  
  [self.window addSubview:self.contactsViewController.view througFadingDuring:0.2];
  [self.contactsViewController displayContactsView:location];
}

/**
 @brief Handle the long press on the Contact ImageView in order to display the contactGridView.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)handleLongPress:(UIGestureRecognizer *)recognizer{
  
  switch ( recognizer.state ) {
    case UIGestureRecognizerStateBegan:
      [self displayContactsGridView:[recognizer locationInView:self.window]];
      break;
      
    default:
      break;
  }
}

/**
 @brief Add a long press gesture recognizer to the Contact ImageView in order to display the contactGridView.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)addLongPressGestureRecognizer{
  UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  recognizer.minimumPressDuration = 0.2;
  [self.thumbnailImageView addGestureRecognizer:recognizer];
  [self.thumbnailImageView setUserInteractionEnabled:YES];
  [recognizer release];
}

/**
 @brief Add a long press gesture recognizer to the Contact ImageView in order to display the contactGridView.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)translationDone{
  performingSwipe = NO;
}

/**
 @brief Add a swipe gesture recognizer to the cell in order to display the delete contact action.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && !performingSwipe) {
    RLLogDebug(@"On a fait un swipe gauche.");
    if (hasRevealedLeftSide && !hasRevealedRightSide) {
      [self hideRemoveContactView];
    }else if (!hasRevealedRightSide && !hasRevealedLeftSide) {
      [self revealMultipleContactsView];
    } 
  }
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && !performingSwipe) {
    RLLogDebug(@"On a fait un swipe droite.");
    if (!hasRevealedLeftSide && !hasRevealedRightSide) {
      [self revealRemoveContactView];
    }else if (hasRevealedRightSide && !hasRevealedLeftSide) {
      [self hideMultipleContactsView];
    }
    
  }
}

/**
 @brief Add a swipe gesture recognizer to the cell in order to display the delete contact action.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (void)addSwipeGestureRecognizer{
  /*
   Create a swipe gesture recognizer to recognize right swipes (the default).
   We're only interested in receiving messages from this recognizer, and the view will take ownership of it, so we don't need to keep a reference to it.
   */
	UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [self addGestureRecognizer:rightRecognizer];
	[rightRecognizer release];
  
  UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [self addGestureRecognizer:leftRecognizer];
	[leftRecognizer release];
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Initialization code
    self.contactsViewController = [[ContactGridViewController alloc] initWithNibName:@"ContactGridViewController" bundle:nil];
    self.eventParticipants = [NSMutableArray arrayWithCapacity:0];
    [self addSwipeGestureRecognizer];
    performingSwipe = NO;
    hasRevealedLeftSide = NO;
    hasRevealedRightSide = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(translationDone) name:kTranslationDone object:nil];
  }
  
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  self.thumbnailImageView = nil;
  self.contactsViewController = nil;
  self.eventParticipants = nil;
  self.peopleContainerView = nil;
  
  [self setCellActionContainerView:nil];
  [self setRemoveUserContainerView:nil];
  [self setRemoveMultipleUsersContainerView:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kTranslationDone object:nil];
  
  [self setEventNameLabel:nil];
  [self setEventImageView:nil];
  [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (void)setFirstAndLastNameLabelText:(NSString *)aString{
  self.firstAndLastNameLabel.text = aString;
}

- (void)setNumberOfExpensesLabelText:(NSString *)aString{
  self.numberOfExpensesLabel.text = aString;
}

- (void)setAmountOfExpensesLabelText:(NSString *)aString{
  self.amountOfExpensesLabel.text = aString;
  
}

- (void)setThumbnailImage:(UIImage *)anImage{
  /*
   if ( self.thumbnailImage_ != anImage ) {
   [self.thumbnailImage_ release];
   self.thumbnailImage_ = [[anImage retain] autorelease];
   
   self.thumbnailImageView.image = self.thumbnailImage_;
   }
   */
  self.thumbnailImageView.image = anImage;
}

- (void)setEvent:(MOEvent *)event{
  self.event_ = [[event retain] autorelease];
  NSMutableArray *contacts = [NSMutableArray arrayWithArray:[self.event_.ParticipatingContacts allObjects]];
  contacts = [contacts orderContactArrayByFirstName];
  self.eventParticipants = contacts;
  [self.eventParticipants replaceContactArrayWithContactViewControllerArray];
  
  // Set the event name label.
  [self.eventNameLabel setText:self.event_.Name];
  // Set the event image view.
  if (event_.EventImage) {
    [self.eventImageView setImage:[UIImage imageWithData:event_.EventImage]];
  }
}

- (void)setContact:(MOContact *)contact{
  self.currentContact_ = contact;
}


@end
