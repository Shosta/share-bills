//
//  EventCellPageContainerModel.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 19/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "EventCellPageContainerModel.h"
#import "NSMutableArray+QueueAdditions.h"
#import "MOContact.h"
#import "Page.h"


@implementation EventCellPageContainerModel


#pragma mark -
#pragma Datasource

- (NSInteger)numberOfPageInPageContainerController{
  // RLLogDebug(@"[EventCellPageContainerModel::numberOfPageInPageContainerController] Il y a %d contact pour ce pageViewContainer.", [contacts_ count]);
  return [contacts_ count];
}

- (Page *)pageContainerController:(PageContainerViewController *)pageController pageForPageControllerAtIndex:(NSInteger)index{
  // RLLogDebug(@"[EventCellPageContainerModel::pageForPageControllerAtIndex] On affiche le contact : %@", [[contacts_ objectAtIndex:index] pageName]);
  return [contacts_ objectAtIndex:index];
}


#pragma mark -
#pragma mark Page and Contact management

- (void)addPageFromContact:(MOContact *)contact{
  // RLLogDebug(@"[EventCellPageContainerModel::addPageViewControllerFromContact] Contact : %@ %@", [contact FirstName], [contact LastName]);
  NSData *thumbnailData = [[[contact ThumbnailImage] copy] autorelease];
  Page *page = [[[Page alloc] initWithName:[contact FirstName] thumbnail:thumbnailData] autorelease];
  // RLLogDebug(@"[EventCellPageContainerModel::addPageViewControllerFromContact] Page : %@: %d", [page pageName], [contacts_ count]);
  
  [contacts_ addObject:page];
}

- (void)dequeueSurnumerousContactsFromContacts:(NSArray *)contacts{
  if ( [contacts count] < [contacts_ count] ) {
    int numberOfDequeue = [contacts_ count] - [contacts count];
    for (int i = 0; i < numberOfDequeue; i++) {
      
      // RLLogDebug(@"[EventCellPageContainerModel::dequeueSurnumerousContactsFromContacts] Page : %@: %d", [[contacts_ lastObject] pageName], [contacts_ count]);
      [contacts_ removeLastObject];
    }
  }
}

- (void)setCurrentContacts:(NSArray *)contacts{
  for (int i = 0; i < [contacts_ count]; i++) {
    Page * currentPage = [contacts_ objectAtIndex:i];
    [currentPage setPageName:[[contacts objectAtIndex:i] FirstName]];
    [currentPage setPageThumbnail:[UIImage imageWithData:[[contacts objectAtIndex:i] ThumbnailImage]]];
    // RLLogDebug(@"[EventCellPageContainerModel::setCurrentContacts] Page : %@", [currentPage pageName]);
  }
}

- (void)enqueueAndDefineSurnumerousContactsFromContacts:(NSArray *)contacts{
  for (int i = [contacts_ count]; i < [contacts count]; i++) {
    [self addPageFromContact:[contacts objectAtIndex:i]];
  }
}

- (void)reuseContactsFromContacts:(NSArray *)contacts{
  [self dequeueSurnumerousContactsFromContacts:contacts];
  
  [self setCurrentContacts:contacts];
  
  [self enqueueAndDefineSurnumerousContactsFromContacts:contacts];
  
  [pageContainerViewController_ viewReload];
}


#pragma mark -
#pragma mark Page Container model creation

- (void)createAndAddPageContainerFromContacts:(NSArray *)contacts{
  [self enqueueAndDefineSurnumerousContactsFromContacts:contacts];
  
  pageContainerViewController_ = [[PageContainerViewController alloc] initWithNibName:@"PageContainerViewController" bundle:nil];
  pageContainerViewController_.pageContainerDataSource = self;
  [pageContainerViewController_ setAnimatePaging:YES];
  [pageContainerViewController_ setAnimateDuration:3];
  
  [pageContainerViewController_.view setFrame:CGRectMake(0, 0, 150, 50)];
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithContactsQueue:(NSArray *)contactsQueue{
  self = [super init];
  if (self) {
    contacts_ = [[NSMutableArray alloc] initWithCapacity:0];
    [self createAndAddPageContainerFromContacts:contactsQueue];
  }
  
  return self;
}




#pragma mark -
#pragma mark Accessors

- (NSArray *)ContactPageViews{
  return contacts_;
}

- (PageContainerViewController *)pageContainerViewController{
  return pageContainerViewController_;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
  [contacts_ release];
  [pageContainerViewController_ release];
  
  [super dealloc];
}

@end

































