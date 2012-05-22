//
//  Tokens.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 30/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTokens.h"

@interface Tokens : NSObject

extern NSString * kContactKey;
extern NSString * kEventKey;

extern NSString * kDisplayContactAdditionNotificationKey;
extern NSString * kAddContactToEventNotificationKey;

extern NSString * kSelectNewContactForEvent;
extern NSString * kRemoveContactSelectionOnEventKey;

extern NSString * kTranslationDone;

extern NSTimeInterval cellPulseDuration;

@end


