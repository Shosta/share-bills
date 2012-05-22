//
//  UIViewController+ImagePicker.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 11/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIViewController+ImagePicker.h"

@implementation UIViewController (ImagePicker)

#pragma mark - Image management

- (void)beginImageContextWithSize:(CGSize)size
{
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    if ([[UIScreen mainScreen] scale] == 2.0) {
      UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
    } else {
      UIGraphicsBeginImageContext(size);
    }
  } else {
    UIGraphicsBeginImageContext(size);
  }
}

- (void)endImageContext
{
  UIGraphicsEndImageContext();
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
  [self beginImageContextWithSize:newSize];
  [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  [self endImageContext];
  return newImage;
}


#pragma mark -
#pragma mark Image picker from library delegate methods

- (BOOL)startMediaBrowserFromViewController: (UIViewController*)controller usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
	
  if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) || (delegate == nil) || (controller == nil)){		
    return NO;
	}//if
	
	
  UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
  mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	
  // Displays saved pictures and movies, if both are available, from the
  // Camera Roll album.
  mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
  // Hides the controls for moving & scaling pictures, or for
  // trimming movies. To instead show the controls, use YES.
  mediaUI.allowsEditing = NO;
  mediaUI.delegate = delegate;
	
  [controller presentModalViewController:mediaUI animated: YES];
	
	[mediaUI release];
  return YES;
}


#pragma mark -
#pragma mark Camera picking photo delegate methods

- (BOOL) startCameraControllerFromViewController:(UIViewController*)controller usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
	
  if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)){	
		NSLog(@"[DetailExpenseImageViewController::startCameraControllerFromViewController] On ne présente pas la vue de la camera.");
    return NO;
	}//if
	
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
  // Displays a control that allows the user to choose picture or
  // movie capture, if both are available:
  cameraUI.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
	
  // Hides the controls for moving & scaling pictures, or for
  // trimming movies. To instead show the controls, use YES.
  cameraUI.allowsEditing = NO;
  
  cameraUI.delegate = delegate;
	
  [controller presentModalViewController:cameraUI animated:YES];
	[cameraUI release];
  return YES;
}

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  //[[picker parentViewController] dismissModalViewControllerAnimated:YES];
  [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - 

/**
 @brief Lance un "UIImagePickerControllerSourceTypeSavedPhotosAlbum" pour choisir une photo dans la librairie de l'utilisateur.
 @author : R. Lavedrine
 @date : 16/12/2010
*/
-(void)choosePhotoFromLibrary{
	[self startMediaBrowserFromViewController:self usingDelegate:self];
}//choosePhotoFromLibrary

/**
 @brief Lance un "UIImagePickerControllerSourceTypeSavedPhotosAlbum" pour prendre une photo depuis l'appareil de l'utilisateur.
 @author : R. Lavedrine
 @date : 16/12/2010
*/
-(void)pickUpPhoto{
	[self startCameraControllerFromViewController:self usingDelegate:self];
}//choosePhotoFromLibrary


-(void)choosePhoto{
	//On crée un UIActionSheet qui va nous permettre de choisir entre prendre une photo et choisir une photo depuis la librairie des photos.
	UIActionSheet *choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Annuler", @"Le bouton d'annulation lors du choix des photos") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Prendre une photo", @"Le bouton pour prendre une photo"), NSLocalizedString(@"Choisir une photo", @"Le bouton pour choisir une photo"), nil];	
	[choosePhotoActionSheet showInView:self.view];
	[choosePhotoActionSheet release];
}//choosePhoto


#pragma mark -
#pragma mark ActionSheet delegate methodes

//Permet de choisir ou de prendre une photo pour illustrer un évènement.
//Les index des boutons sont les suivants : 0 : Prendre une photo; 1 : Choisir une photo depuis la bibliothèque.
//@author : R. Lavedrine
//@date : 16/12/2010
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	switch (buttonIndex) {
		case 0:
			RLLogDebug(@"On prend une photo");
			[self pickUpPhoto];
			break;
		case 1:
			RLLogDebug(@"On choisit une photo");
			[self choosePhotoFromLibrary];
			break;
		default:
			break;
	}//switch
	
}//actionSheet: clickedButtonAtIndex:



@end
