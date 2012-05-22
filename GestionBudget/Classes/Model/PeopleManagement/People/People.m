//
//  People.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 07/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "People.h"


@implementation People


#pragma mark -
#pragma mark Contact component management

/**
 Get the people in the adress book from the peopleId and get the image thumbnail for this contact if he has one. Else, we return the default image.
 @author : Rémi Lavedrine
 @date : 08/09/2011
 @remarks : (facultatif)
 */
- (UIImage *)getContactThumbnail{
  return nil;
}

/**
 Get the people in the adress book from the peopleId and get the image thumbnail for this contact if he has one. Else, we return the default image.
 @author : Rémi Lavedrine
 @date : 08/09/2011
 @remarks : (facultatif)
 */
- (NSData *)getContactThumbnailData{
  return nil;
}

#pragma mark -
#pragma mark Object life cycle

- (id)init{
  self = [super init];
  if (self) {
    
  }
  
  return self;
}


#pragma mark -
#pragma Public accessors, setter takes ownership

- (ABRecordID)ABContactId{
  return contactUserID_;
}

- (NSString *)firstName{
  return firstName_;
}

- (NSString *)lastName{
  return lastName_;
}

- (NSString *)phoneNumber{
  return phoneNumber_;
}

- (NSString *)emailAddress{
  return emailAddress_;
}

- (UIImage *)contactThumbnail{
  return contactThumbnail_; 
}

- (int)contactUserID{
  return contactUserID_;
}

- (void) setContactUserID:(ABRecordID)ABContactId{
  contactUserID_ = ABContactId;
}

- (void)setFirstName:(NSString *)firstName{
  firstName_ = firstName;
}

- (void)setLastName:(NSString *)lastName{
  lastName_ = lastName;
}

- (void)setPhoneNumber:(NSString *)phoneNumber{
  phoneNumber_ = phoneNumber;
}

- (void)setEmailAddress:(NSString *)emailAddress{
  emailAddress_ = emailAddress;
}

- (void)setContactThumbnail:(UIImage *)contactThumbnail{
  contactThumbnail_ = contactThumbnail;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
  [firstName_ release];
  [lastName_ release];
  [phoneNumber_ release];
  [emailAddress_ release];
  
  [super dealloc];
}


@end
