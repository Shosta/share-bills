//
//  EventCellPageContainerModel.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 19/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageContainerViewController.h"
#import "PageContainerViewControllerDatasource.h"
#import "PageContainerViewControllerDelegate.h"


@interface EventCellPageContainerModel : NSObject <PageContainerViewControllerDelegate, PageContainerViewControllerDatasource> {
  
  
@private 
  NSMutableArray *contacts_;
  PageContainerViewController *pageContainerViewController_;
}


- (id)initWithContactsQueue:(NSArray *)contactsQueue;


// Page and Contact management
- (void)reuseContactsFromContacts:(NSArray *)contacts;


// Accessors
// - (NSArray *)ContactPageViews;
- (PageContainerViewController *)pageContainerViewController;

@end
