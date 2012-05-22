//
//  PeopleSelectionTableViewCell.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 12/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeopleSelectionTableViewCell : UITableViewCell {
  
  UILabel *peopleFirstName;
  UILabel *peopleLastName;
  UIImageView *peopleThumbnailImageView;
  UIImage *peopleThumbnail;
  UIImageView *thumbnailCopy;
  
@private
  NSIndexPath *cellCurrentIndexPath_;
}

@property (nonatomic, retain) IBOutlet UILabel *peopleFirstName;
@property (nonatomic, retain) IBOutlet UILabel *peopleLastName;
@property (nonatomic, retain) IBOutlet UIImageView *peopleThumbnailImageView;
@property (nonatomic, retain) UIImage *peopleThumbnail;

// Long press gesture management
- (void)addLongPressGestureRecognizer;

// Accessors
- (NSString *)peopleFirstNameLabelText;
- (void)setPeopleFirstNameLabelText:(NSString *)aString;
- (NSString *)peopleLastNameLabelText;
- (void)setPeopleLastNameLabelText:(NSString *)aString;
- (UIImage *)peopleThumbnail;
- (void)setPeopleThumbnail:(UIImage *)anImage;

@end
