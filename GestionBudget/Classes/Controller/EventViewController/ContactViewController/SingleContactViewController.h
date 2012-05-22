//
//  SingleContactViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOContact.h"

@interface SingleContactViewController : UIViewController{
  UIImageView *contactThumbnailImageView;
  UILabel *contactNameLabel;
  
  MOContact *currentContact;
}
@property (nonatomic, retain) IBOutlet UIImageView *contactThumbnailImageView;
@property (nonatomic, retain) IBOutlet UILabel *contactNameLabel;

@property (retain, nonatomic) MOContact *currentContact;

#pragma mark - Accessors
- (void)defineUI;
- (void)setContactThumbnailImage:(UIImage *)image;
- (void)setContactNameLabelText:(NSString *)text;

@end
