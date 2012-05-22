//
//  NSArray+ContactViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOContact.h"

@interface NSMutableArray (ContactViewController)

- (void)replaceContactArrayWithContactViewControllerArray;
- (NSMutableArray *)orderContactArrayByFirstName;
- (MOContact *)firstContactFromEventAscending;

@end
