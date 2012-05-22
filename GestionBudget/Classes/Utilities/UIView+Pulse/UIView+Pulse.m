//
//  UIView+Pulse.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIView+Pulse.h"
#import "NSObject+PerformSelectorOnMainThreadMultipleArgs.h"

@implementation UIView (Pulse)

- (void)scaleToX:(NSNumber *)sx y:(NSNumber *)sy during:(NSTimeInterval)duration{
  
  // Setup the animation
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];	
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  // The transform matrix
  self.transform = CGAffineTransformMakeScale([sx doubleValue], [sy doubleValue]);
  
  // Commit the changes
  [UIView commitAnimations];
  
}

- (void)pulseDuringTimeInterval:(NSTimeInterval)duration{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:0.1
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     CGAffineTransform transform  = CGAffineTransformMakeScale(0.8, 0.8);
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                   }completion:^(BOOL finished){
                     if (finished) {
                       [UIView animateWithDuration:0.1
                                             delay:0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                          CGAffineTransform transform  = CGAffineTransformMakeScale(1.0, 1.0);
                                          self.transform = transform;
                                          // Commit the changes
                                          [UIView commitAnimations];
                                        }completion:nil];
                     }
                   }];
}

- (void)pulseDuring:(NSNumber *)duration{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:[duration floatValue]];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:0.1
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     CGAffineTransform transform  = CGAffineTransformMakeScale(0.8, 0.8);
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                   }completion:^(BOOL finished){
                     if (finished) {
                       [UIView animateWithDuration:0.1
                                             delay:0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                          CGAffineTransform transform  = CGAffineTransformMakeScale(1.0, 1.0);
                                          self.transform = transform;
                                          // Commit the changes
                                          [UIView commitAnimations];
                                        }completion:nil];
                     }
                   }];
}

@end
