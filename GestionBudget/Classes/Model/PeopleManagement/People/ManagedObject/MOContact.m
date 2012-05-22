//
//  MOContact.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright (c) 2011 Orange Labs. All rights reserved.
//

#import "MOContact.h"
#import "MOEvent.h"
#import "MOExpense.h"


@implementation MOContact
@dynamic FirstChar;
@dynamic EmailAddress;
@dynamic FirstName;
@dynamic LastName;
@dynamic PhoneNumber;
@dynamic ThumbnailImage;
@dynamic ParticipatedEvents;
@dynamic ContactExpenses;
@dynamic uniqueID;

- (void)addParticipatedEventsObject:(MOEvent *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ParticipatedEvents"] addObject:value];
    [self didChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeParticipatedEventsObject:(MOEvent *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ParticipatedEvents"] removeObject:value];
    [self didChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addParticipatedEvents:(NSSet *)value {    
    [self willChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ParticipatedEvents"] unionSet:value];
    [self didChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeParticipatedEvents:(NSSet *)value {
    [self willChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ParticipatedEvents"] minusSet:value];
    [self didChangeValueForKey:@"ParticipatedEvents" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addContactExpensesObject:(MOExpense *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ContactExpenses"] addObject:value];
    [self didChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactExpensesObject:(MOExpense *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"ContactExpenses"] removeObject:value];
    [self didChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContactExpenses:(NSSet *)value {    
    [self willChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ContactExpenses"] unionSet:value];
    [self didChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContactExpenses:(NSSet *)value {
    [self willChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"ContactExpenses"] minusSet:value];
    [self didChangeValueForKey:@"ContactExpenses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)desc{
  RLLogDebug(@"%@ %@; %d", self.FirstName, self.LastName, [self.uniqueID intValue]);
}


@end
