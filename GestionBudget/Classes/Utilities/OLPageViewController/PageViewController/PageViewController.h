//
//  PresentationViewController.h
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PageViewController : UIViewController {
    
  UILabel *nameLabel;
  UIImageView *thumbnailImageView;
  
@private
  NSString *name_;
  UIImage *thumbnail_;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;


// Accessors
- (void)setThumbnailImage:(UIImage *)anImage;
- (void)setNameLabelText:(NSString *)aString;


@end
