//
//  EventTableViewCell.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 14/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventTableViewCell.h"
#import "PageContainerViewController.h"
#import "MOContact.h"
#import "Page.h"
#import "UIView+ShadowAddition.h"


@implementation EventTableViewCell

@synthesize eventNameLabel;
@synthesize nbParticipatingContactLabel;
@synthesize eventImage;
@synthesize eventImageView;


#pragma mark -
#pragma Datasource

- (NSInteger)numberOfPageInPageContainerController{
  
  return [contacts_ count];
}

- (Page *)pageContainerController:(PageContainerViewController *)pageController pageForPageControllerAtIndex:(NSInteger)index{
  Page *page = [[Page alloc] init];
  [page setPageName:[(MOContact *)[contacts_ objectAtIndex:index] FirstName]];
  [page setPageThumbnail:[UIImage imageWithData:[(MOContact *)[contacts_ objectAtIndex:index] ThumbnailImage]]];
  
  return [page autorelease];
}


#pragma mark -
#pragma mark PageViewController management

- (void)createAndAddPageContainer{
  PageContainerViewController *pageContainerViewController = [[PageContainerViewController alloc] initWithNibName:@"PageContainerViewController" bundle:nil];
  pageContainerViewController.pageContainerDataSource = self;
  [pageContainerViewController setAnimatePaging:YES];
  [pageContainerViewController setAnimateDuration:3];
  
  [pageContainerViewController.view setFrame:CGRectMake(20, 175, 150, 50)];
  [self addSubview:pageContainerViewController.view];
  [pageContainerViewController release];
}

- (void)drawRect:(CGRect)rect{
  [super drawRect:rect];
  [self createAndAddPageContainer];
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
#pragma mark Memory management

- (void)dealloc
{
  [contacts_ release];
  
  [super dealloc];
}


#pragma mark -
#pragma mark Accessors

- (UIImage *)eventImage{
  return eventImage;
}

- (void)setEventImage:(UIImage *)anImage{
  if ( eventImage != anImage ) {
    [eventImage release];
    eventImage = [[anImage retain] autorelease];
    
    self.eventImageView.image = self.eventImage;
  }
}

- (NSString *)eventNameLabelText{
  return [[self.eventNameLabel.text copy] autorelease];
}

- (void)setEventNameLabelText:(NSString *)aString{
  self.eventNameLabel.text = [[aString copy] autorelease];  
}

- (NSString *)nbParticipatingContactLabelText{
  return [[self.nbParticipatingContactLabel.text copy] autorelease];
}

- (void)setNbParticipatingContactLabelText:(NSString *)aString{
  self.nbParticipatingContactLabel.text = [[aString copy] autorelease];  
}

- (void)setContacts:(NSArray *)contacts{
  
  contacts_ = [contacts retain];
}

@end
