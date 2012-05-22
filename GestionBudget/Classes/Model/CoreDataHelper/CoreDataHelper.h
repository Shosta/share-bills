//
//  CoreDataHelper.h
//  GestionBudget
//
//  Created by Rémi Lavedrine on 19/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOContact.h"
#import "MOEvent.h"

@interface CoreDataHelper : NSObject


#pragma mark - Core Data contact management
+ (void)addNewContact:(MOContact *)correspondingContact toEvent:(MOEvent *)correspondingEvent;


#pragma mark - Fetch request management
+ (NSArray *)fetchRequest:(NSString*)entityName onlyObjectID:(BOOL)onlyObjectID sort:(NSSortDescriptor*)sort predicate:(NSPredicate*)predicate context:(NSManagedObjectContext*)context;
+ (NSArray *)fetchRequest:(NSString*)entityName relationship:(NSArray*)relationship sort:(NSSortDescriptor*)sort predicate:(NSPredicate*)predicate context:(NSManagedObjectContext*)context;
+ (NSArray *)fetchRequest:(NSString*)entityName onlyObjectID:(BOOL)onlyObjectID sort:(NSSortDescriptor*)sort  context:(NSManagedObjectContext*)context;
+ (NSArray*) fetchRequest:(NSString*)entityName context:(NSManagedObjectContext*)context;
@end
