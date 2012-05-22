//
//  EventsViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
  
  UITableView *tableView;
  
@private
  NSFetchedResultsController *fetchedResultsController_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


@end
