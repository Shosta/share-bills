//
//  CoreDataHelper.m
//  GestionBudget
//
//  Created by Rémi Lavedrine on 19/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper


#pragma mark - Core Data contact management

/**
 @brief Add a contact to an event.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
+ (void)addNewContact:(MOContact *)correspondingContact toEvent:(MOEvent *)correspondingEvent{
  // If the correspondingEvent is nil, the user have certainly disposed the contact on the |add event| button. We should not add any contact to any event.
  if ( correspondingEvent != nil ) {
    // Add contact and event relationships
    NSMutableSet *contactToAdd = [[NSMutableSet alloc] initWithSet:[correspondingEvent ParticipatingContacts]];
    [contactToAdd addObject:correspondingContact];
    [correspondingEvent setParticipatingContacts:contactToAdd];
    [contactToAdd release];
    
    NSMutableSet *eventToAdd = [[NSMutableSet alloc] initWithSet:[correspondingContact ParticipatedEvents]];
    [eventToAdd addObject:correspondingEvent];
    [correspondingContact setParticipatedEvents:eventToAdd];
    [eventToAdd release];
    
    RLLogDebug(@"Le nombre de contact pour l'evenement %@: %d; Le nombre d'evenement auxquels participent ce contact %@: %d", [correspondingEvent Name], [[correspondingEvent ParticipatingContacts] count], [correspondingContact FirstName], [[correspondingContact ParticipatedEvents] count]);
    
    // Firing Notification to display a statusView to tell the user that a contact has been added to an event.
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:correspondingContact, kContactKey, correspondingEvent, kEventKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDisplayContactAdditionNotificationKey object:dict];
  }
}


#pragma mark - Fetch request management

+ (NSArray*) fetchRequest:(NSString*)entityName onlyObjectID:(BOOL)onlyObjectID sort:(NSSortDescriptor*)sort predicate:(NSPredicate*)predicate context:(NSManagedObjectContext*)context {
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
	
	if(onlyObjectID){
		[request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
  }
  else {
    [request setIncludesPropertyValues:YES];
    [request setIncludesSubentities:YES];
  }
	
	if(sort!=nil){
		[request setSortDescriptors:[NSArray arrayWithObject:sort]];
	}
	
	if(predicate!=nil){
		[request setPredicate:predicate];
	}
	
	NSError * error = nil;
	NSArray *resultRequest=nil;
	resultRequest = [context executeFetchRequest:request error:&error];
	if (error !=nil) {
		RLLogError(@"occured error => %@",error);
	}
	[request release];
	return resultRequest;
}

+ (NSArray*)fetchRequest:(NSString*)entityName relationship:(NSArray*)relationship sort:(NSSortDescriptor*)sort predicate:(NSPredicate*)predicate context:(NSManagedObjectContext*)context {
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
	
	if(sort!=nil){
		[request setSortDescriptors:[NSArray arrayWithObject:sort]];
	}
	
	if(predicate!=nil){
		[request setPredicate:predicate];
	}
	
	if (relationship != nil)
		[request setRelationshipKeyPathsForPrefetching:relationship];
	
	NSError *error = nil;
	NSArray *resultRequest = nil;
	resultRequest = [context executeFetchRequest:request error:&error];
	if (error !=nil) {
		RLLogError(@"occured error => %@",error);
	}
	[request release];
	return resultRequest;
}

+ (NSArray*) fetchRequest:(NSString*)entityName onlyObjectID:(BOOL)onlyObjectID sort:(NSSortDescriptor*)sort  context:(NSManagedObjectContext*)context
{
	return [self fetchRequest:entityName onlyObjectID:onlyObjectID sort:sort predicate:nil context:context];
}

+ (NSArray*) fetchRequest:(NSString*)entityName context:(NSManagedObjectContext*)context
{
	return [self fetchRequest:entityName onlyObjectID:NO sort:nil predicate:nil context:context];
}



@end
