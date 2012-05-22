//
//  PeopleSelectionViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeopleSelectionViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    
@private
  NSFetchedResultsController *fetchedResultsController_;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)getDataModelIfNeeded;

@end
