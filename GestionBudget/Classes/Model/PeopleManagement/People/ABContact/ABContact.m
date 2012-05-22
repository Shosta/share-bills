//
//  ABContact.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 09/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "ABContact.h"
#import <QuartzCore/QuartzCore.h>


@implementation ABContact

#pragma mark -
#pragma mark AdressBook management

/**
 Get the people in the adress book from the peopleId and get the image thumbnail for this contact if he has one. Else, we return the default image.
 @author : Rémi Lavedrine
 @date : 08/09/2011
 @remarks : (facultatif)
 */
- (UIImage *)getContactThumbnail{
  ABAddressBookRef addressBook = ABAddressBookCreate();
  ABRecordRef aRecord = ABAddressBookGetPersonWithRecordID(addressBook, contactUserID_);
  
  
  // Adding contact Image
  UIImage *image;
  if( ABPersonHasImageData(aRecord) ){
    CFDataRef imageData = ABPersonCopyImageDataWithFormat(aRecord, kABPersonImageFormatThumbnail);
    image = [[[UIImage imageWithData:(NSData *)imageData] retain] autorelease];
    CFRelease(imageData);
  }else{
    image = [UIImage imageNamed:@"default_contact.png"];
  }
  
  CFRelease(addressBook);
  return image;
}

/**
 Get the people in the adress book from the peopleId and get the image thumbnail for this contact if he has one. Else, we return the default image.
 @author : Rémi Lavedrine
 @date : 08/09/2011
 @remarks : (facultatif)
 */
- (NSData *)getContactThumbnailData{
  ABAddressBookRef addressBook = ABAddressBookCreate();
  ABRecordRef aRecord = ABAddressBookGetPersonWithRecordID(addressBook, contactUserID_);
  
  
  // Adding contact Image
  NSData *image;
  if( ABPersonHasImageData(aRecord) ){
    CFDataRef imageData = ABPersonCopyImageDataWithFormat(aRecord, kABPersonImageFormatThumbnail);
    image = [[(NSData *)imageData retain] autorelease];
    CFRelease(imageData);
  }else{
    image = (NSData *)UIImagePNGRepresentation([UIImage imageNamed:@"default_contact.png"]);
  }
  
  CFRelease(addressBook);
  return image;
}


@end
