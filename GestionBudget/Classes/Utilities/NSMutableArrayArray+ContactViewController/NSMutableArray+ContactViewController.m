//
//  NSArray+ContactViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "NSMutableArray+ContactViewController.h"
#import "SingleContactViewController.h"

@implementation NSMutableArray (ContactViewController)

/**
 @brief Replace a NSMUtableArray of MOContact objects by a NSMutableArray containing SingleContactViewController build from the corresponding MOConctact objects from the initial NSMutableArray.
 @author : Rémi Lavedrine
 @date : 06/04/2012
 @remarks : (facultatif)
 */
- (void)replaceContactArrayWithContactViewControllerArray{
  for (int index = 0; index < [self count]; index++) {
    MOContact *contact = [self objectAtIndex:index];
    SingleContactViewController *contactViewController = [[[SingleContactViewController alloc] initWithNibName:@"SingleContactViewController" bundle:nil] autorelease];
    [contactViewController setCurrentContact:contact];
    [contactViewController defineUI];
    
    [self replaceObjectAtIndex:index withObject:contactViewController];
  }
  
}

/**
 @brief Order the contact array by FirstName ascending.
 @author : Rémi Lavedrine
 @date : 11/04/2012
 @remarks : (facultatif)
 */
- (NSMutableArray *)orderContactArrayByFirstName{
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"FirstName" ascending:YES];
  [self sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  [sortDescriptor release];
  
  return self;
}

/**
 @brief Return the first contact from the array ascending by first name.
 Return nil if there is none.
 @author : Rémi Lavedrine
 @date : 17/04/2012
 @remarks : (facultatif)
 */
- (MOContact *)firstContactFromEventAscending{
  NSMutableArray *contacts = [self orderContactArrayByFirstName];
  if ( [contacts count] > 0) {
    return [contacts objectAtIndex:0];
  }
  
  return nil;
}

@end
