//
//  AddEventOperation.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "AddEventOperation.h"
#import "GestionBudgetAppDelegate.h"
#import "MOEvent.h"
#import "DataModelSavingManager.h"
#import "Tokens.h"


@implementation AddEventOperation


#pragma mark -
#pragma mark Add event management

/**
 Add an event in a MOEvent object set the attributes and save it non concurrently in the CoreData model.
 @author : Rémi Lavedrine
 @date : 12/08/2011
 @remarks : (facultatif)
 */
- (void)addNewEvent{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  // Get contact
  NSManagedObjectContext * context = [(GestionBudgetAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
  MOEvent *aEvent = (MOEvent *)[NSEntityDescription insertNewObjectForEntityForName:@"MOEvent" inManagedObjectContext:context];
  [aEvent setName:eventName_];
  [aEvent setEventImage:eventImageData_];
  NSDate *now = [NSDate date];
  [aEvent setCreationDate:now];
  [aEvent setLastModificationDate:now];
   
  RLLogDebug(@"[AddEventOperation::addNewEvent] Event : %@", [aEvent description]);
  // Save event non concurently
  [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
  
  
  [pool release];
}


#pragma mark -
#pragma mark Operation management

- (void)main{
	@try {
		
    [self performSelectorInBackground:@selector(addNewEvent) withObject:nil];
    
	}
	@catch (NSException * e) {
		// gestion erreur
	}
	@finally {
    
	}
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithEventName:(NSString *)name eventImageData:(NSData *)imageData{
  self = [super init];
  if (self) {
    eventName_ = [name retain];
    eventImageData_ = [imageData retain];
  }
  
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
  [eventName_ release];
  
  [super dealloc];
}

@end
