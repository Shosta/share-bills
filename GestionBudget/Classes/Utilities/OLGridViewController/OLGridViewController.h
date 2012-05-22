//
//  CustomImagePicker.h
//  CustomImagePicker
//
//  Created by Ray Wenderlich on 1/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OLGridViewController : UIViewController {
	NSMutableArray *_images;
	NSMutableArray *_thumbs;
	UIImage *_selectedImage;
}

@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *thumbs;
@property (nonatomic, retain) UIImage *selectedImage;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)addImage:(UIImage *)image;

@end
