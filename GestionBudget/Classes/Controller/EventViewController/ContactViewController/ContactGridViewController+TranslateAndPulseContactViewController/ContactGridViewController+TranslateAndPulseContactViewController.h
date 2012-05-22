//
//  ContactGridViewController+TranslateAndPulseContactViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "ContactGridViewController.h"

@interface ContactGridViewController (TranslateAndPulseContactViewController)

// - (void)setInitialCenterForContactViewControllers;
- (void)moveAllContactViewControllerToFinalPosition;
#define DELAY 0.03
- (void)moveAllContactViewControllerToInitialPosition;
#define ADD_SUBVIEW_DELAY 0.02
- (void)createContactsStack;
#define REMOVE_SUBVIEW_DELAY 0.02
- (void)removeContactsStacks;

@end
