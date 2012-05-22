//
//  AlertViewManager.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 17/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "AlertViewManager.h"

@implementation AlertViewManager

#pragma mark -
#pragma mark Share
// Vous n'avez pas entré de nom pour votre évènement. Merci d'en ajouter un.
+ (void)showNoEventNameAlert:(id)delegate{
	UIAlertView *alertView = [[[UIAlertView alloc]
                             initWithTitle:@"Information"
                             message:@"Vous n'avez pas entré de nom pour votre évènement. Merci d'en ajouter un."
                             delegate:delegate
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil] 
                            autorelease];
	[alertView show];
}

@end
