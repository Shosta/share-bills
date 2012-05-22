//
//  MOContact.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright (c) 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOEvent, MOExpense;

@interface MOContact : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * FirstChar;
@property (nonatomic, retain) NSString * EmailAddress;
@property (nonatomic, retain) NSString * FirstName;
@property (nonatomic, retain) NSString * LastName;
@property (nonatomic, retain) NSString * PhoneNumber;
@property (nonatomic, retain) NSData * ThumbnailImage;
@property (nonatomic, retain) NSSet* ParticipatedEvents;
@property (nonatomic, retain) NSSet* ContactExpenses;
@property (nonatomic, retain) NSNumber * uniqueID;


- (void)desc;

@end