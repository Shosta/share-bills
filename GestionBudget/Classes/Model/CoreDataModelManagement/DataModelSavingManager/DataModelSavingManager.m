//
//  DataModelSavingManager.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 09/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "DataModelSavingManager.h"
#import "GestionBudgetAppDelegate.h"


@implementation DataModelSavingManager

#pragma mark -
#pragma mark Non conccurent saving

- (void)nonConcurrentSaveOnMainThread{
  if ( !isCurrentlySaving_ ) {
    isCurrentlySaving_ = YES;
    // Save contact in CoreData model. It has to be done on main thread and on a nonConcurent access.
    [APP_DELEGATE saveContext];
    
    isCurrentlySaving_ = NO;
  }
}

- (void)nonConcurrentSaveContext{
  [self performSelectorOnMainThread:@selector(nonConcurrentSaveOnMainThread) withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark Singleton declaration and methods

static DataModelSavingManager *sharedDataModelSavingManager = nil;

+ (DataModelSavingManager *)sharedManager
{
  if (sharedDataModelSavingManager == nil) {
    sharedDataModelSavingManager = [[super allocWithZone:NULL] init];
  }
  
  return sharedDataModelSavingManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (id)retain
{
  return self;
}

- (NSUInteger)retainCount
{
  return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
  //do nothing
}

- (id)autorelease
{
  return self;
}

#pragma mark -
#pragma mark Custom Init

- (void)initManager{
  isCurrentlySaving_ = NO;
}
@end
