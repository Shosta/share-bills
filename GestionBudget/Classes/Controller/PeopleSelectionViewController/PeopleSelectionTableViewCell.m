//
//  PeopleSelectionTableViewCell.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 12/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PeopleSelectionTableViewCell.h"
#import "MOContact.h"
#import "UILabel+Size.h"


@interface PeopleSelectionTableViewCell () {
  UIImageView *thumbnailCopy_;
  NSIndexPath *cellCurrentIndexPath_;
}
@property (nonatomic, retain) UIImageView *thumbnailCopy_;
@property (nonatomic, retain) NSIndexPath *cellCurrentIndexPath_;

@end

@implementation PeopleSelectionTableViewCell

@synthesize peopleFirstName;
@synthesize peopleLastName;
@synthesize peopleThumbnailImageView;
@synthesize peopleThumbnail;
@synthesize thumbnailCopy_;
@synthesize cellCurrentIndexPath_;


#pragma mark -
#pragma mark Cell MoContact

/**
 * @brief Get a contact (Managed Object) from a cell Location in the tableView.
 * @author Rémi Lavedrine
 * @date 20/02/2012
 */
- (void)getCellMOContactFromCellLocation:(CGPoint)location{
  NSIndexPath *cellIndexPath = [(UITableView *)[self superview] indexPathForRowAtPoint:location];
  self.cellCurrentIndexPath_ = cellIndexPath;
  RLLogDebug(@"x : %f; y : %f", location.x, location.y);
  RLLogDebug(@"%@; self : %@", cellIndexPath, self.cellCurrentIndexPath_);
}


#pragma mark -
#pragma mark Image creation and modification

/**
 * @brief Create an image from a contact (the peopleThumbnail member ivar) on a location.
 * @author Rémi Lavedrine
 * @date 20/02/2012
 */
- (void)createImageOnViewLocation:(CGPoint)touchLocationOnWindow{
  UIImage *thumbnailImageCopy = [peopleThumbnail copy];
  thumbnailCopy_ = [[UIImageView alloc] initWithFrame:CGRectMake(touchLocationOnWindow.x - peopleThumbnailImageView.frame.size.width / 2 + 30, 
                                                                touchLocationOnWindow.y - peopleThumbnailImageView.frame.size.height / 2- 30, 
                                                                peopleThumbnailImageView.frame.size.width, 
                                                                peopleThumbnailImageView.frame.size.height)];
  [thumbnailCopy_ setImage:thumbnailImageCopy];
  [thumbnailImageCopy release];
  [self.window addSubview:thumbnailCopy_];
  [thumbnailCopy_ release];
  [thumbnailCopy_ setAlpha:0.70];
  [UIView animateWithDuration:0.2 animations:^{
    [thumbnailCopy_ setTransform:CGAffineTransformMakeScale(1.25, 1.25)];
    [thumbnailCopy_ setAlpha:0.75];
  }];
}

/**
 * @brief Move the thumbnail image (thumbnailCopy_ member ivar) from its current location to a new location.
 * @author Rémi Lavedrine
 * @date 20/02/2012
 */
- (void)moveThumbnailCopyToNewLocation:(CGPoint)newLocation{
  thumbnailCopy_.center = CGPointMake(newLocation.x + 30,
                                      newLocation.y - 30);
}

/**
 * @brief Remove the thumbnail image (thumbnailCopy_ member ivar) from its super view.
 * @author Rémi Lavedrine
 * @date 20/02/2012
 */
- (void)removeThumbnailCopy{
  [UIView animateWithDuration:0.2 animations:^{
    [thumbnailCopy_ setTransform:CGAffineTransformIdentity];
    [thumbnailCopy_ setAlpha:1.0];
  } completion:^(BOOL finished){
    [thumbnailCopy_ removeFromSuperview];
  }];
}


#pragma mark -
#pragma mark Long Press recognizer

/**
 * @brief Handle a long press
 * @author Rémi Lavedrine
 * @date 20/02/2012
 * @remarks Create a thumbnail, move it, fire a notification to save a contact on an event and remove the thumbnail from its super view depending on the recognizer state.
 */
- (void)handleLongPress:(UIGestureRecognizer *)recognizer{
  
  switch ( recognizer.state ) {
    case UIGestureRecognizerStateBegan:
      RLLogDebug(@"On commence le long press sur : %@ à %f, %f", [self description], [recognizer locationInView:self.window].x, [recognizer locationInView:self.window].y);
      [self createImageOnViewLocation:[recognizer locationInView:self.window]];
      [self getCellMOContactFromCellLocation:[recognizer locationInView:[self superview]]];
      break;
      
      
    case UIGestureRecognizerStateChanged:
      // RLLogDebug(@"On change le long press");
      [self moveThumbnailCopyToNewLocation:[recognizer locationInView:self.window]];
      break;
      
    case UIGestureRecognizerStateEnded:
      RLLogDebug(@"On finit le long press à %f, %f", [recognizer locationInView:self.window].x, [recognizer locationInView:self.window].y);
      if ( [recognizer locationInView:self.window].x > kUpperViewRevealWidth ) { // Adding contact on event if contact is on an event cell.
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.cellCurrentIndexPath_, [NSNumber numberWithFloat:thumbnailCopy_.center.y], nil]
                                                           forKeys:[NSArray arrayWithObjects:@"CellIndexPathOnSelectionContactList", @"LocationOnEventsView", nil]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddContactToEventNotificationKey object:dict];
        [dict release];
      }
      [self removeThumbnailCopy];
      break;
      
    case UIGestureRecognizerStateCancelled:
      RLLogDebug(@"On a arrete le long press");
      [self removeThumbnailCopy];
      break;
      
    case UIGestureRecognizerStateFailed:
      RLLogDebug(@"On a echoue le long press");
      [self removeThumbnailCopy];
      break;
      
    default:
      break;
  }
  
}

/**
 @brief Add a long press gesture to the cell.
 @author : Rémi Lavedrine
 @date : 12/09/2011
 @remarks : (facultatif)
 */
- (void)addLongPressGestureRecognizer{
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPressGesture.minimumPressDuration = 0.2;
  [self addGestureRecognizer:longPressGesture];
  [longPressGesture release];
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}


#pragma mark - View life cycle

- (void)redrawLabels{
  CGPoint origin = self.peopleFirstName.frame.origin;
  CGSize expectedLabelSize = [self.peopleFirstName getSize];
  [self.peopleFirstName  setFrame:CGRectMake(origin.x, origin.y, expectedLabelSize.width, expectedLabelSize.height)];
  
  expectedLabelSize = [self.peopleLastName getSize];
  [self.peopleLastName setFrame:CGRectMake(origin.x + self.peopleFirstName.frame.size.width + 5, origin.y - 1, expectedLabelSize.width, expectedLabelSize.height)];
}

- (void)layoutSubviews{
  [self redrawLabels];
}


#pragma mark -
#pragma mark Accessors

- (UIImage *)peopleThumbnail{
  return peopleThumbnail;
  // return [[peopleThumbnail copy] autorelease];
}

- (void)setPeopleThumbnail:(UIImage *)anImage{
  if ( peopleThumbnail != anImage ) {
    peopleThumbnail = [[anImage copy] autorelease];
    
    self.peopleThumbnailImageView.image = self.peopleThumbnail;
  }
}

- (NSString *)peopleFirstNameLabelText{
  return self.peopleFirstName.text;
  // return [[self.peopleFirstName.text copy] autorelease];
}

- (void)setPeopleFirstNameLabelText:(NSString *)aString{
  self.peopleFirstName.text = [aString copy];  
}

- (NSString *)peopleLastNameLabelText{
  return self.peopleLastName.text;
  // return [[self.peopleLastName.text copy] autorelease];
  
}

- (void)setPeopleLastNameLabelText:(NSString *)aString{
  self.peopleLastName.text = [aString copy];  
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  peopleFirstName = nil;
  peopleLastName = nil;
  peopleThumbnailImageView = nil;
  peopleThumbnail = nil;
  
  [self setPeopleThumbnail:nil];
  // cellCurrentIndexPath_ = nil;
  
  [self setThumbnailCopy_:nil];
  [self setCellCurrentIndexPath_:nil];
  
  [super dealloc];
}


@end
