//
//  EventsViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate> {
  
  UITableView *tableView;
  
@private
  UIViewController *rootViewController_;
  NSFetchedResultsController *fetchedResultsController_;
  BOOL animateContactsHorizontalScroll;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


// Accessors
- (void)setRootViewController:(UIViewController *)viewController;

@end
