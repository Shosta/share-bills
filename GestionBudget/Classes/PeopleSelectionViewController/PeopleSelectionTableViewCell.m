//
//  PeopleSelectionTableViewCell.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 12/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PeopleSelectionTableViewCell.h"
#import "MOContact.h"


@implementation PeopleSelectionTableViewCell

@synthesize peopleFirstName;
@synthesize peopleLastName;
@synthesize peopleThumbnailImageView;
@synthesize peopleThumbnail;


#pragma mark -
#pragma mark Cell MoContact

- (void)getCellMOContactFromCellLocation:(CGPoint)location{
  NSIndexPath *cellIndexPath = [(UITableView *)[self superview] indexPathForRowAtPoint:location];
  cellCurrentIndexPath_ = [[cellIndexPath retain] autorelease];
}

#pragma mark -
#pragma mark Image creation and modification

- (void)createImageOnViewLocation:(CGPoint)touchLocationOnWindow{
  UIImage *thumbnailImageCopy = [peopleThumbnail copy];
  thumbnailCopy = [[UIImageView alloc] initWithFrame:CGRectMake(touchLocationOnWindow.x - peopleThumbnailImageView.frame.size.width / 2 + 30, 
                                                                touchLocationOnWindow.y - peopleThumbnailImageView.frame.size.height / 2- 30, 
                                                                peopleThumbnailImageView.frame.size.width, 
                                                                peopleThumbnailImageView.frame.size.height)];
  [thumbnailCopy setImage:thumbnailImageCopy];
  [thumbnailImageCopy release];
  [self.window addSubview:thumbnailCopy];
  [thumbnailCopy release];
  
  [thumbnailCopy setAlpha:0.70];
  [UIView animateWithDuration:0.2 animations:^{
    [thumbnailCopy setTransform:CGAffineTransformMakeScale(1.25, 1.25)];
    [thumbnailCopy setAlpha:0.75];
  }];
}

- (void)moveThumbnailCopyToNewLocation:(CGPoint)newLocation{
  thumbnailCopy.center = CGPointMake(newLocation.x + 30,
                                      newLocation.y - 30);
}

- (void)removeThumbnailCopy{
  [UIView animateWithDuration:0.2 animations:^{
    [thumbnailCopy setTransform:CGAffineTransformIdentity];
    [thumbnailCopy setAlpha:1.0];
  } completion:^(BOOL finished){
    [thumbnailCopy removeFromSuperview];
  }];
}


#pragma mark -
#pragma mark Long Press recognizer

- (void)handleLongPress:(UIGestureRecognizer *)recognizer{
  
  switch ( recognizer.state ) {
    case UIGestureRecognizerStateBegan:
      NSLog(@"On commence le long press sur : %@ à %f, %f", [self description], [recognizer locationInView:self.window].x, [recognizer locationInView:self.window].y);
      [self createImageOnViewLocation:[recognizer locationInView:self.window]];
      [self getCellMOContactFromCellLocation:[recognizer locationInView:[self superview]]];
      break;
      
    case UIGestureRecognizerStateChanged:
      // NSLog(@"On change le long press");
      [self moveThumbnailCopyToNewLocation:[recognizer locationInView:self.window]];
      break;
      
    case UIGestureRecognizerStateEnded:
      NSLog(@"On finit le long press à %f, %f", [recognizer locationInView:self.window].x, [recognizer locationInView:self.window].y);
      NSDictionary *dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:cellCurrentIndexPath_, [NSNumber numberWithFloat:thumbnailCopy.center.y], nil]
                                                       forKeys:[NSArray arrayWithObjects:@"CellIndexPathOnSelectionContactList", @"LocationOnEventsView", nil]];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"AddContactToEvent" object:dict];
      [dict release];
      [self removeThumbnailCopy];
      break;
      
    case UIGestureRecognizerStateCancelled:
      NSLog(@"On a arrete le long press");
      [self removeThumbnailCopy];
      break;
      
    case UIGestureRecognizerStateFailed:
      NSLog(@"On a echoue le long press");
      [self removeThumbnailCopy];
      break;
      
    default:
      break;
  }
}

/**
 Add a long press gesture to the cell.
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


#pragma mark -
#pragma mark Accessors

- (UIImage *)peopleThumbnail{
  return peopleThumbnail;
}

- (void)setPeopleThumbnail:(UIImage *)anImage{
  if ( peopleThumbnail != anImage ) {
    [peopleThumbnail release];
    peopleThumbnail = [[anImage retain] autorelease];
    
    self.peopleThumbnailImageView.image = self.peopleThumbnail;
  }
}

- (NSString *)peopleFirstNameLabelText{
  return [[self.peopleFirstName.text copy] autorelease];
}

- (void)setPeopleFirstNameLabelText:(NSString *)aString{
  self.peopleFirstName.text = [[aString copy] autorelease];  
}

- (NSString *)peopleLastNameLabelText{
  return [[self.peopleLastName.text copy] autorelease];
}

- (void)setPeopleLastNameLabelText:(NSString *)aString{
  self.peopleLastName.text = [[aString copy] autorelease];  
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  [peopleFirstName release];
  [peopleLastName release];
  [peopleThumbnailImageView release];
  
  [super dealloc];
}

@end
