//
//  PeopleOperation.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 09/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PeopleOperation.h"
#import "DataModelSavingManager.h"
#import "ABContact.h"
#import "MOContact.h"
#import <AddressBook/AddressBook.h>
#import "GestionBudgetAppDelegate.h"
#import "AddressBookHelper.h"

@implementation PeopleOperation


#pragma mark -
#pragma mark CoreData contact management

/**
 @brief Add a contact in a MOContact object set the attributes and save it non concurrently in the CoreData model.
 @author : Rémi Lavedrine
 @date : 09/08/2011
 @remarks : (facultatif)
 */
- (void)addNewContact:(People *)newContact{
  // Get contact
  NSManagedObjectContext * context = [(GestionBudgetAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  MOContact *aContact = (MOContact *)[NSEntityDescription insertNewObjectForEntityForName:@"MOContact" inManagedObjectContext:context];
  [aContact setFirstName:[newContact firstName]];
  [aContact setLastName:[newContact lastName]];
  [aContact setThumbnailImage:[newContact getContactThumbnailData]];
  if ([[newContact firstName] length] > 0) {
    [aContact setFirstChar:[[[newContact firstName] substringWithRange:NSMakeRange(0,1)] uppercaseString]];
  }else{
    [aContact setFirstChar:@"#"];
  }
  [aContact setUniqueID:[NSNumber numberWithInt:[newContact contactUserID]]];
  
  RLLogDebug(@"Contact : %@", [aContact description]);
}


#pragma mark -
#pragma mark AdressBook management

/**
 @brief Grab the content from the adress book from |startIndex| to |lastIndex| and store each contact in a People object and place it in an array.
 @author : Rémi Lavedrine
 @date : 01/07/2011
 @remarks : The array returned is sorted.
 If you want to populate with the all adressBook, set lastIndex to a negative number (-1 for instance).
 */
- (void)populateListWithAdressBookContentFromStartIndex:(int)startIndex toLastIndex:(int)lastIndex{
  
  ABAddressBookRef addressBook = ABAddressBookCreate();
  NSMutableArray *people = [[[(NSArray*) ABAddressBookCopyArrayOfAllPeople(addressBook) autorelease] mutableCopy] autorelease];
  [people sortUsingFunction:(int (*)(id, id, void *) ) ABPersonComparePeopleByName context:(void*)ABPersonGetSortOrdering()];
  
  if (lastIndex < 0) {
    lastIndex = [people count];
  } 
  for (int i = startIndex; i < lastIndex; i++)
  {
    ABRecordRef aRecord = [people objectAtIndex:i];
    
    // If the contact is not saved in Core Data add it to Core Data.
    if ( ![AddressBookHelper isThereCoreDataContactWithId:ABRecordGetRecordID(aRecord)] ) {
      ABContact *currentABContact = [[ABContact alloc] init];
      
      // Adding the recordID
      [currentABContact setContactUserID:ABRecordGetRecordID(aRecord)];
      
      // Adding first Name
      NSString *firstName = (NSString *)ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
      if (firstName) {
        [currentABContact setFirstName:firstName];
      }else{
        [currentABContact setFirstName:@""];
      }
      [firstName release];
      
      // Adding Last Name
      NSString *lastName = (NSString *)ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
      if (lastName) {
        [currentABContact setLastName:lastName];
      }else{
        [currentABContact setLastName:@""];
      }
      [lastName release];
      
      // Adding the contact thumbnail
      [currentABContact setContactThumbnail:[currentABContact getContactThumbnail]];
      
      // Adding the contact to the CoreData Model.
      [self addNewContact:currentABContact];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"aContactHasBeenAdded" object:[NSIndexPath indexPathForRow:i inSection:0]];
      [currentABContact release];
    }
  }
  
  
  CFRelease(addressBook);
}

/**
 @brief Delete all the contacts in Core Data which are not anymore in the address book.
 @author : Rémi Lavedrine
 @date : 19/03/2012
 @remarks : (facultatif)
 */
- (void)removeAllUnusedContacts{
  
}

/**
 @brief Grab the content from the adress book and store each contact in a People object and place it in an array.
 @author : Rémi Lavedrine
 @date : 09/09/2011
 @remarks : The array returned is sorted.
 */
- (void)populateListWithAdressBookContent{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  
  [self populateListWithAdressBookContentFromStartIndex:0 toLastIndex:-1];
  
  // Save contact non concurently
  [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
  
  [pool release];
}


#pragma mark -
#pragma mark Operation management

- (void)main{
	@try {
		
    // [self populateListWithAdressBookContentFromStartIndex:0 toLastIndex:-1];
    [self performSelectorInBackground:@selector(populateListWithAdressBookContent) withObject:nil];
    
	}
	@catch (NSException * e) {
		// gestion erreur
	}
	@finally {
    
	}
}

@end
