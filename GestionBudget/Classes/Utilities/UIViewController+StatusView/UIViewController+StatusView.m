//
//  UIViewController+StatusView.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 30/03/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIViewController+StatusView.h"
#import "OLStatusView.h"

@implementation UIViewController (StatusView)

#pragma mark -
#pragma mark Status view management

/**
 @brief Display a status.
 @author : Rémi Lavedrine
 @date : 30/03/2012
 @remarks : (facultatif)
 */
- (void)displayStatusViewWithMessage:(NSString *)message{
  // NSString *p  = [NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]];
  OLStatusView *statusView = [[OLStatusView alloc] initWithStatusLabel:message 
                                                              textFont:[UIFont fontWithName:@"Helvetica" size:16] 
                                                           orientation:UIInterfaceOrientationPortrait 
                                                  translationDirection:DownToUp];
  statusView.delegate = self;
  [statusView animateShowOnView:self.view.window];
  [statusView performSelector:@selector(animateRemove) withObject:nil afterDelay:2];
  [statusView release];
}

/**
 @brief Display a status to tell the user that the contac has been correctly added to the event.
 @author : Rémi Lavedrine
 @date : 14/09/2011
 @remarks : (facultatif)
 */
- (void)displayStatusViewForContactAddition:(MOContact *)contact onEvent:(MOEvent *)event{
  // NSString *p  = [NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]];
  OLStatusView *statusView = [[OLStatusView alloc] initWithStatusLabel:[NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]] 
                                                              textFont:[UIFont fontWithName:@"Helvetica" size:16] 
                                                           orientation:UIInterfaceOrientationPortrait 
                                                  translationDirection:DownToUp];
  statusView.delegate = self;
  [statusView animateShowOnView:self.view.window];
  [statusView performSelector:@selector(animateRemove) withObject:nil afterDelay:2];
  [statusView release];
}

/**
 @brief Display a status to tell the user that the contac has been correctly added to the event from a notification.
 @author : Rémi Lavedrine
 @date : 30/03/2012
 @remarks : (facultatif)
 */
- (void)displayStatusViewForContactAddition:(NSNotification *)notification{
  NSDictionary *dict = [notification object];
  MOContact *contact = [dict objectForKey:kContactKey];
  MOEvent *event = [dict objectForKey:kEventKey];
  
  [self displayStatusViewWithMessage:[NSString stringWithFormat:@"%@ a été ajouté à l'évènement %@", [contact FirstName], [event Name]]];
}


@end
