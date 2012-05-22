//
//  AddEventViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddEventViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  UITextField *eventNameTextField;
    NSData *imageData;
  
}

@property (nonatomic, retain) IBOutlet UITextField *eventNameTextField;
@property (nonatomic, retain) NSData *imageData;
@property (retain, nonatomic) IBOutlet UIButton *addEventImageButton;
@property (retain, nonatomic) IBOutlet UIButton *saveEventButton;

- (IBAction)displayEditEventNameUI;
- (IBAction)undisplayEditEventNameUI;

// Action management
- (IBAction)saveAndDismissView;
- (IBAction)cancelAction;
- (IBAction)pickUpEventImage:(id)sender;

@end
