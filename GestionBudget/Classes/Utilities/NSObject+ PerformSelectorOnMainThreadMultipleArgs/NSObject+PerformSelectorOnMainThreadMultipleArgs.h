//
//  NSObject+PerformSelectorOnMainThreadMultipleArgs.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelectorOnMainThreadMultipleArgs)
-(void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait withObjects:(NSObject *)object, ... NS_REQUIRES_NIL_TERMINATION;
-(void)performSelectorOnMainThread:(SEL)selector afterDelay:(NSTimeInterval)delay withObjects:(NSObject *)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
@end
