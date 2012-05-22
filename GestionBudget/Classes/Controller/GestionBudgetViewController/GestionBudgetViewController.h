//
//  GestionBudgetViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLViewControllerWithUpperViewController.h"
#import "PeopleSelectionViewController.h"

@interface GestionBudgetViewController : OLViewControllerWithUpperViewController {
  
  PeopleSelectionViewController *peopleSelectionViewController;
  UIBarButtonItem *displayLowerViewBarButtonItem;
  UIBarButtonItem *modifiedTableViewBarButtonItem;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *displayLowerViewBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *modifiedTableViewBarButtonItem;

@end
