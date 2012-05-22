//
//  EventTableViewCell.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 14/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContainerViewController.h"


@interface EventTableViewCell : UITableViewCell <PageContainerViewControllerDelegate, PageContainerViewControllerDatasource> {
    
  UILabel *eventNameLabel;
  UILabel *nbParticipatingContactLabel;
  UIImage *eventImage;
  UIImageView *eventImageView;
  
  @private 
  NSArray *contacts_;
}

@property (nonatomic, retain) IBOutlet UILabel *eventNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *nbParticipatingContactLabel;
@property (nonatomic, retain) UIImage *eventImage;
@property (nonatomic, retain) IBOutlet UIImageView *eventImageView;

// Accessors
- (UIImage *)eventImage;
- (void)setEventImage:(UIImage *)anImage;
- (NSString *)eventNameLabelText;
- (void)setEventNameLabelText:(NSString *)aString;
- (NSString *)nbParticipatingContactLabelText;
- (void)setNbParticipatingContactLabelText:(NSString *)aString;
- (void)setContacts:(NSArray *)contacts;


@end
