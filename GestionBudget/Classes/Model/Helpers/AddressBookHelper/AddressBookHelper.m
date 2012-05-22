//
//  AddressBookHelper.m
//  GestionBudget
//
//  Created by Rémi Lavedrine on 19/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "AddressBookHelper.h"
#import <AddressBook/AddressBook.h>
#import "MOContact.h"
#import "GestionBudgetAppDelegate.h"
#import "DataModelSavingManager.h"
#import "CoreDataHelper.h"

@implementation AddressBookHelper

/**
 @brief Check if there is a contact in Core Data with a specific uniqueID.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (BOOL)isThereCoreDataContactWithId:(int)uniqueID{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueID == %d)", uniqueID];
  NSArray *contacts = [CoreDataHelper fetchRequest:@"MOContact" relationship:nil sort:nil predicate:predicate context:[APP_DELEGATE managedObjectContext]];
  
  return [contacts count] > 0;
}

/**
 @brief Check if there is a contact in the address book with a specific uniqueID.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (BOOL)isThereAddressBookContactWithId:(int)uniqueID{
  BOOL result = NO;
  NSArray *allRecordsFromAddressBook = [self getAllRecordsFromAddressBook];
  for ( int i = 0; i < [allRecordsFromAddressBook count]; i++ ) {
    ABRecordRef aRecord = [allRecordsFromAddressBook objectAtIndex:i];
    
    if ( ABRecordGetRecordID(aRecord) == uniqueID ) {
      result = YES;
      break;
    }
  }
  
  return result;
}

/**
 @brief Get the Core Data contact described by its uniqueID.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (MOContact *)getCDContactWithUniqueID:(int)uniqueID{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uniqueID == %d)", uniqueID];
  NSArray *contacts = [CoreDataHelper fetchRequest:@"MOContact" relationship:nil sort:nil predicate:predicate context:[APP_DELEGATE managedObjectContext]];
  
  return [contacts lastObject];
}

/**
 @brief Get the number of contacts in the address book.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (int)getContactNumber{
  ABAddressBookRef addressBook = ABAddressBookCreate();
  NSMutableArray *people = [[[(NSArray*) ABAddressBookCopyArrayOfAllPeople(addressBook) autorelease] mutableCopy] autorelease];  
  CFRelease(addressBook);
  
  return [people count];
}

/**
 @brief Return an array that contains all the contacts from the address book.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (NSArray *)getAllRecordsFromAddressBook{
  ABAddressBookRef addressBook = ABAddressBookCreate();
  NSMutableArray *people = [[[(NSArray*) ABAddressBookCopyArrayOfAllPeople(addressBook) autorelease] mutableCopy] autorelease];  
  CFRelease(addressBook);
  
  return people;
}

/**
 @brief Return an array that contains all the contacts from the address book.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (NSArray *)getAllContactsFromCoreData{
  NSArray *contacts = [CoreDataHelper fetchRequest:@"MOContact" context:[APP_DELEGATE managedObjectContext]];
  
  return contacts;
}

/**
 @brief Delete the contacts in Core Data.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (void)deleteAllContacts:(NSArray *)contacts{
  NSManagedObjectContext *managedObjectContext = [APP_DELEGATE managedObjectContext];
  for ( MOContact *contact in contacts ) {
    [managedObjectContext deleteObject:contact];
  }
  
  [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
}

/**
 @brief Delete the contacts that are in Core Data and not anymore in the Address Book.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
+ (void)deleteOldContacts{
  NSArray *allContactsFromCoreData = [self getAllContactsFromCoreData];
  for ( MOContact *contact in allContactsFromCoreData ) {
    [contact desc];
    if ( ![self isThereAddressBookContactWithId:[contact.uniqueID intValue]] ) {
      [[APP_DELEGATE managedObjectContext] deleteObject:contact];
    }
  }
  
  [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
}



@end
