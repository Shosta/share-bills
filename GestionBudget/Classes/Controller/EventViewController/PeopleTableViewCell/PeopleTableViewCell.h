//
//  PeopleTableViewCell.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//
// The cell describing a contact from an event.
// It contains as well a process to delete this contact from the event. This process is in a view located under the current view describing the contact.
// Swyping to the left or right reveal the view and handle the deleting process.
//

#import <UIKit/UIKit.h>
#import "MOEvent.h"
#import "MOContact.h"


@interface PeopleTableViewCell : UITableViewCell {
  
  UIImageView *thumbnailImageView;
  UILabel *firstAndLastNameLabel;
  UILabel *numberOfExpensesLabel;
  UILabel *amountOfExpensesLabel;

}

@property (retain, nonatomic) IBOutlet UIImageView *eventImageView;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (retain, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *firstAndLastNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberOfExpensesLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountOfExpensesLabel;
@property (retain, nonatomic) IBOutlet UIView *peopleContainerView;
@property (retain, nonatomic) IBOutlet UIView *cellActionContainerView;
@property (retain, nonatomic) IBOutlet UIView *removeUserContainerView;
@property (retain, nonatomic) IBOutlet UIView *removeMultipleUsersContainerView;



// Gesture management
- (void)addLongPressGestureRecognizer;


// Accessors
- (void)setFirstAndLastNameLabelText:(NSString *)aString;
- (void)setNumberOfExpensesLabelText:(NSString *)aString;
- (void)setAmountOfExpensesLabelText:(NSString *)aString;
- (void)setThumbnailImage:(UIImage *)anImage;
- (void)setEvent:(MOEvent *)event;
- (void)setContact:(MOContact *)contact;

@end
