//
//  MOExpense.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright (c) 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOContact, MOEvent;

@interface MOExpense : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * Amount;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSNumber * Latitude;
@property (nonatomic, retain) NSNumber * Longitude;
@property (nonatomic, retain) NSDate * CreationDate;
@property (nonatomic, retain) MOContact * Owner;
@property (nonatomic, retain) MOEvent * EventOwner;

@end
