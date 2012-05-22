//
//  ContactsViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D4MGridScrollView.h"

@interface ContactsViewController : UIViewController <D4MGridScrollViewDataSource, D4MGridScrollViewDelegate> {
  D4MGridScrollView *gridScrollView;
}

@property (nonatomic, retain) D4MGridScrollView *gridScrollView;


- (IBAction)removeView;


// Accessors
- (void)setContactArray:(NSArray *)contactArray;

@end
