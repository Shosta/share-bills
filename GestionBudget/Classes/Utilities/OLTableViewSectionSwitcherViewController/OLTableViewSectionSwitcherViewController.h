//
//  OLTableViewSectionSwitcherViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//
// This controller creates a buttons grid from the header title contained in the rootTableViewController.
// When the user hits one button, this view is removed and the rootTableViewController is scrolled to the first cell of this section.
// 

#import <UIKit/UIKit.h>

@class PeopleSelectionViewController;

@interface OLTableViewSectionSwitcherViewController : UIViewController {
  
@private
  PeopleSelectionViewController *rootTableViewController_;
  NSArray *lettersArray_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootTableViewController:(PeopleSelectionViewController *)rootTableViewController;
- (void)moveToSection:(id)sender;
@end
