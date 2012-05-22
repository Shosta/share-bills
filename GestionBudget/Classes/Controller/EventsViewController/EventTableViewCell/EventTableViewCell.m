//
//  EventTableViewCell.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 14/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Page.h"
#import "MOEvent.h"


@interface EventTableViewCell () {
  UIImage *eventImage_;
  EventCellPageContainerModel *eventCellPageContainerModel_;
}
@property (nonatomic, retain) UIImage *eventImage_;
@property (nonatomic, retain) EventCellPageContainerModel *eventCellPageContainerModel_;
@property (nonatomic, retain) MOEvent *currentEvent;

@end

@implementation EventTableViewCell

@synthesize eventNameLabel;
@synthesize nbParticipatingContactLabel;
@synthesize eventImageView;
@synthesize pageContainerView;
@synthesize creationDateLabel;
@synthesize lastModificationDateLabel;
@synthesize deleteEventButton;
@synthesize eventImage_;
@synthesize eventCellPageContainerModel_;
@synthesize currentEvent;


- (IBAction)deleteEvent:(id)sender{
  RLLogDebug(@"On efface l'evenement");
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

- (void)stopAnimation{
  // eventCellPageContainerModel_ setAnimat  
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{ 
  [self setEventNameLabel:nil];
  [self setNbParticipatingContactLabel:nil];
  [self setEventImageView:nil];
  [self setPageContainerView:nil];
  [self setCreationDateLabel:nil];
  [self setLastModificationDateLabel:nil];
  [self setEventImage_:nil];
  [self setEventCellPageContainerModel_:nil];
  [self setCurrentEvent:nil];
  
  [deleteEventButton release];
  [super dealloc];
}


#pragma mark -
#pragma mark Date formatter

- (NSString *)formatDate:(NSDate *)date{
  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  return [dateFormatter stringFromDate:date];
}

#pragma mark -
#pragma mark Accessors

- (UIImage *)eventImage{
  return eventImage_;
}

- (void)setEventImage:(UIImage *)anImage{
  /*if ( eventImage_ != anImage ) {
   [eventImage_ release];
   eventImage_ = [[anImage retain] autorelease];
   */
  if (anImage) {
    self.eventImageView.image = anImage;
  }
}

- (NSString *)eventNameLabelText{
  // return [[self.eventNameLabel.text copy] autorelease];
  return self.eventNameLabel.text;
}

- (void)setEventNameLabelText:(NSString *)aString{
  // self.eventNameLabel.text = [[aString copy] autorelease]; 
  self.eventNameLabel.text = aString; 
}

- (NSString *)nbParticipatingContactLabelText{
  // return [[self.nbParticipatingContactLabel.text copy] autorelease];
  return self.nbParticipatingContactLabel.text;
}

- (void)setNbParticipatingContactLabelText:(NSString *)aString{
  // self.nbParticipatingContactLabel.text = [[aString copy] autorelease];  
  self.nbParticipatingContactLabel.text = aString;  

}

- (void)setPageContainerViewFromController:(UIViewController *)aController{
  if ( [[self.pageContainerView subviews] count] > 0) {
    for (UIView *view in [self.pageContainerView subviews]) {
      [view removeFromSuperview];
    }
  }
  [self.pageContainerView addSubview:aController.view];
}

- (void)setCreationDateLabelText:(NSDate *)creationDate{
  [creationDateLabel setText:[NSString stringWithFormat:@"Créé le %@", [self formatDate:creationDate]]];
}

- (void)setLastModificationDateLabelText:(NSDate *)modificationDate{
  [lastModificationDateLabel setText:[NSString stringWithFormat:@"Modifié le %@", [self formatDate:modificationDate]]];
}

/*
 - (void)setContacts:(NSArray *)contacts{
 
 contacts_ = contacts;
 }
 */

@end
