//
//  MOEvent.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright (c) 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOContact, MOExpense;

@interface MOEvent : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * LastModificationDate;
@property (nonatomic, retain) NSDate * CreationDate;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSData * EventImage;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSSet* ParticipatingContacts;
@property (nonatomic, retain) NSSet* EventOwner;

- (void)removeParticipatingContactsObject:(MOContact *)value;

@end
