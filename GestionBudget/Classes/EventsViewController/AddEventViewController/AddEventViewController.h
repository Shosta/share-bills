//
//  AddEventViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddEventViewController : UIViewController {
  UITextField *eventNameTextField;
}

@property (nonatomic, retain) IBOutlet UITextField *eventNameTextField;

// Action management
- (IBAction)saveAndDismissView;
- (IBAction)cancelAction;

@end
