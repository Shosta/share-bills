//
//  AddExpenseOperation.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOEvent.h"
#import "MOContact.h"


@interface AddExpenseOperation : NSOperation {
  
@private
  NSString *expenseName_;
  NSString *expenseDescription_;
  NSNumber *expenseAmount_;
  MOEvent *event_;
  MOContact *contact_;
}

- (id)initWithExpenseName:(NSString *)name Description:(NSString *)description Amount:(int)amount Event:(MOEvent *)event Contact:(MOContact *)contact;

@end
