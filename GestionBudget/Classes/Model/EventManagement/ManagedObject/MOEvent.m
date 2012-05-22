//
//  MOEvent.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright (c) 2011 Orange Labs. All rights reserved.
//

#import "MOEvent.h"
#import "MOContact.h"
#import "MOExpense.h"


@implementation MOEvent
@dynamic LastModificationDate;
@dynamic CreationDate;
@dynamic Name;
@dynamic EventImage;
@dynamic Description;
@dynamic Latitude;
@dynamic Longitude;
@dynamic ParticipatingContacts;
@dynamic EventOwner;

- (void)addParticipatingContactsObject:(MOContact *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ParticipatingContacts"] addObject:value];
    [self didChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeParticipatingContactsObject:(MOContact *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ParticipatingContacts"] removeObject:value];
    [self didChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addParticipatingContacts:(NSSet *)value {    
    [self willChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ParticipatingContacts"] unionSet:value];
    [self didChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeParticipatingContacts:(NSSet *)value {
    [self willChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ParticipatingContacts"] minusSet:value];
    [self didChangeValueForKey:@"ParticipatingContacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addEventOwnerObject:(MOExpense *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"EventOwner"] addObject:value];
    [self didChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeEventOwnerObject:(MOExpense *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"EventOwner"] removeObject:value];
    [self didChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addEventOwner:(NSSet *)value {    
    [self willChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"EventOwner"] unionSet:value];
    [self didChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeEventOwner:(NSSet *)value {
    [self willChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"EventOwner"] minusSet:value];
    [self didChangeValueForKey:@"EventOwner" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
