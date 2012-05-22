//
//  UIViewController+ImagePicker.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 11/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIViewController (ImagePicker) <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> 

-(void)choosePhoto;
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
