//
//  PeopleSelectionViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLTableViewSectionSwitcherViewController;

@interface PeopleSelectionViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
  
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)getDataModelIfNeeded;

@end
