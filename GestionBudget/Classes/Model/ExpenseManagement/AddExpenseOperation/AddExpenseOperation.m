//
//  AddExpenseOperation.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 03/10/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "AddExpenseOperation.h"
#import "GestionBudgetAppDelegate.h"
#import "DataModelSavingManager.h"
#import "MOExpense.h"

@implementation AddExpenseOperation

#pragma mark -
#pragma mark Add expense management

/**
 Add an expense in a MOExpense object set the attributes and save it non concurrently in the CoreData model.
 @author : Rémi Lavedrine
 @date : 03/10/2011
 @remarks : (facultatif)
 */
- (void)addNewExpense{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  if ( event_ != nil ) {
    NSManagedObjectContext * context = [(GestionBudgetAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    MOExpense *aExpense = (MOExpense *)[NSEntityDescription insertNewObjectForEntityForName:@"MOExpense" inManagedObjectContext:context];
    [aExpense setName:expenseName_];
    [aExpense setDescription:expenseDescription_];
    [aExpense setAmount:expenseAmount_];
    
    
    NSDate *now = [NSDate date];
    [aExpense setCreationDate:now];
    
    [aExpense setOwner:contact_];
    [aExpense setEventOwner:event_];
    
    RLLogDebug(@"[AddExpenseOperation::addNewExpense] Event : %@", [event_ description]);
    // Save event non concurently
    [[DataModelSavingManager sharedManager] nonConcurrentSaveContext];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExpenseAdded" object:nil];
  }
  
  [pool release];
}


#pragma mark -
#pragma mark Operation management

- (void)main{
	@try {
		
    [self performSelectorInBackground:@selector(addNewExpense) withObject:nil];
    
	}
	@catch (NSException * e) {
		// gestion erreur
	}
	@finally {
    
	}
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithExpenseName:(NSString *)name Description:(NSString *)description Amount:(int)amount Event:(MOEvent *)event Contact:(MOContact *)contact{
  self = [super init];
  if (self) {
    expenseName_ = [name retain];
    expenseDescription_ = [description retain];
    expenseAmount_ = [[NSNumber alloc] initWithInt:amount];
    
    event_ = [event retain];
    contact_ = [contact retain];
  }
  
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
  [expenseName_ release];
  [expenseDescription_ release];
  [expenseAmount_ release];
  
  [event_ release];
  [contact_ release];
  
  [super dealloc];
}
@end
