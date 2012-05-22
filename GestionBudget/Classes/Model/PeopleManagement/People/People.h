//
//  People.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 07/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//
// This class represents a Contact from the adressBook and its main info (First name, Last name, phone numbers, email adress, etc...)
// 

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>


@interface People : NSObject {

  ABRecordID contactUserID_;
  NSString *firstName_;
  NSString *lastName_;
  NSString *phoneNumber_;
  NSString *emailAddress_;
  UIImage *contactThumbnail_;
}
/*
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *emailAddress;
*/

// Contact component management
- (UIImage *)getContactThumbnail;
- (NSData *)getContactThumbnailData;

// Public accessors, setter takes ownership
- (NSString *)firstName;
- (NSString *)lastName;
- (NSString *)phoneNumber;
- (NSString *)emailAddress;
- (UIImage *)contactThumbnail;
- (int) contactUserID;
- (void) setContactUserID:(ABRecordID)ABContactId;
- (void)setFirstName:(NSString *)firstName;
- (void)setLastName:(NSString *)lastName;
- (void)setPhoneNumber:(NSString *)phoneNumber;
- (void)setEmailAddress:(NSString *)emailAddress;
- (void)setContactThumbnail:(UIImage *)contactThumbnail;

@end

