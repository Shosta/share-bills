//
//  AddEventViewController+ImagePicker.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 11/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "AddEventViewController+ImagePicker.h"

@implementation AddEventViewController (ImagePicker)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
  UIImage *originalImage, *editedImage, *imageToUse;
	
  // Handle a still image picked from a photo album
  if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
		
    if (editedImage) {
      imageToUse = editedImage;
    } else {
      imageToUse = originalImage;
    }
    imageToUse = [self imageWithImage:imageToUse scaledToSize:CGSizeMake(150, 150)];
    // Do something with imageToUse
		self.imageData = UIImagePNGRepresentation(imageToUse);
    [self.addEventImageButton setBackgroundImage:imageToUse forState:UIControlStateNormal];
  }
	
  [picker dismissModalViewControllerAnimated:YES];
}

@end
