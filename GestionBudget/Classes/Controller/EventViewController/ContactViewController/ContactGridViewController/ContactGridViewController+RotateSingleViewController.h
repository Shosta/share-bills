//
//  ContactGridViewController+RotateSingleViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "ContactGridViewController.h"

@interface ContactGridViewController (RotateSingleViewController)

- (void)addContactViewControllersToView;
- (void)revealContactViewControllersThroughRotation;
- (void)hideContactViewControllersThroughRotation;

@end
