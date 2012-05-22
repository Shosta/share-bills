//
//  EventViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOEvent.h"
#import "MOContact.h"


@interface EventViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
  
  NSFetchedResultsController *fetchedResultsController_;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(MOEvent *)event;

@end
