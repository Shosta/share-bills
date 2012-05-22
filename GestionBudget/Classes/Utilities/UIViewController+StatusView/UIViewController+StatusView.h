//
//  UIViewController+StatusView.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 30/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOContact.h"
#import "MOEvent.h"

@interface UIViewController (StatusView)

- (void)displayStatusViewForContactAddition:(NSNotification *)notification;

@end
