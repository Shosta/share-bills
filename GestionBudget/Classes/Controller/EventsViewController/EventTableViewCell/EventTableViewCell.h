//
//  EventTableViewCell.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 14/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventCellPageContainerModel.h"


@interface EventTableViewCell : UITableViewCell  {
    
  UILabel *eventNameLabel;
  UILabel *nbParticipatingContactLabel;
  UIImageView *eventImageView;
  UIView *pageContainerView;
  UILabel *creationDateLabel;
  UILabel *lastModificationDateLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *nbParticipatingContactLabel;
@property (nonatomic, retain) IBOutlet UIImageView *eventImageView;
@property (nonatomic, retain) IBOutlet UIView *pageContainerView;
@property (nonatomic, retain) IBOutlet UILabel *creationDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastModificationDateLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteEventButton;


// Accessors
- (UIImage *)eventImage;
- (void)setEventImage:(UIImage *)anImage;
- (NSString *)eventNameLabelText;
- (void)setEventNameLabelText:(NSString *)aString;
- (NSString *)nbParticipatingContactLabelText;
- (void)setNbParticipatingContactLabelText:(NSString *)aString;
- (void)setPageContainerViewFromController:(UIViewController *)aController;
- (void)setCreationDateLabelText:(NSDate *)creationDate;
- (void)setLastModificationDateLabelText:(NSDate *)modificationDate;


@end
