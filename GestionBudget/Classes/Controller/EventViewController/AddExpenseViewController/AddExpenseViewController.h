//
//  AddExpenseViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOEvent.h"
#import "MOContact.h"


@interface AddExpenseViewController : UIViewController {
  
  UITextField *expenseNameTextField;
  UITextField *expenseDescriptionTextField;
  UITextField *expenseAmountTextField;
  
 @private
  MOEvent *event_;
  MOContact *contact_;
}

@property (nonatomic, retain) IBOutlet UITextField *expenseNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *expenseDescriptionTextField;
@property (nonatomic, retain) IBOutlet UITextField *expenseAmountTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(MOEvent *)event contact:(MOContact *)contact;

@end
