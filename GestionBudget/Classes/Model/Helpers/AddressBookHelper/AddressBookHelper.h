//
//  AddressBookHelper.h
//  GestionBudget
//
//  Created by Rémi Lavedrine on 19/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookHelper : NSObject

+ (BOOL)isThereCoreDataContactWithId:(int)uniqueID;
+ (BOOL)isThereCoreDataContactWithId:(int)uniqueID;
+ (int)getContactNumber;
+ (NSArray *)getAllRecordsFromAddressBook;
+ (void)deleteAllContacts:(NSArray *)contacts;
+ (void)deleteOldContacts;

@end
