//
//  UIView+Translation.m
//  OrangeEtMoi
//
//  Created by Rémi Lavedrine on 10/02/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIView+Translation.h"
#import "UIView+Pulse.h"
#import "NSObject+PerformSelectorOnMainThreadMultipleArgs.h"

@implementation UIView (Translation)

- (void)translateBounceToX:(NSInteger)tx curve:(int)curve during:(NSTimeInterval)duration{
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:curve];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:duration
                        delay:0
                      options:UIViewAnimationCurveLinear
                   animations:^{
                     
                     CGAffineTransform transform = CGAffineTransformMakeTranslation(tx + tx / 20, 0);
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                     if (finished) {
                       [UIView animateWithDuration:duration / 4
                                             delay:0
                                           options:UIViewAnimationCurveLinear 
                                        animations:^{
                                          
                                          CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, 0);
                                          self.transform = transform;
                                          // Commit the changes
                                          [UIView commitAnimations];
                                        }completion:^(BOOL finished){
                                          if (finished) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:kTranslationDone object:nil];
                                          }
                                        }];
                       
                     }
                     
                   }];
}

- (void)translateToX:(NSInteger)tx Y:(NSInteger)ty curve:(int)curve during:(NSTimeInterval)duration{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:curve];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:duration
                        delay:0
                      options:UIViewAnimationCurveLinear
                   animations:^{
                     
                     CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                     if (finished) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:kTranslationDone object:nil];
                     }
                   }];
}

- (void)translateToX:(NSInteger)tx Y:(NSInteger)ty during:(NSTimeInterval)duration{
  
  [self translateToX:tx Y:ty curve:UIViewAnimationCurveEaseIn during:duration];
  
}

- (void)translateToInitialPositionDuring:(NSTimeInterval)duration{
  // Setup the animation
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  // The transform matrix
  self.transform = CGAffineTransformIdentity;
  
  // Commit the changes
  [UIView commitAnimations];
}

- (void)translateAndPulseToX:(NSInteger)tx Y:(NSInteger)ty during:(NSTimeInterval)duration{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:duration
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     
                     CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                     if (finished) {
                       [UIView animateWithDuration:0.1
                                             delay:0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                          
                                          self.center = CGPointMake(self.center.x + tx, self.center.y + ty);
                                          
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
                                                             }completion:^(BOOL finished){
                                                               if (finished) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kTranslationDone object:nil];
                                                               }
                                                             }];
                                          }
                                        }];
                       
                     }
                     
                   }];
}

- (void)translateAndPulseToInitialPositionDuring:(NSTimeInterval)duration{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [UIView animateWithDuration:duration
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     
                     // CGAffineTransform transform = CGAffineTransformIdentity;
                     CGAffineTransform transform = CGAffineTransformMakeScale(0.8, 0.8);
                     // transform = CGAffineTransformRotate(transform, kDegreesToRadian(90));
                     self.transform = transform;
                     // Commit the changes
                     [UIView commitAnimations];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                     if (finished) {
                       [UIView animateWithDuration:duration
                                             delay:0
                                           options:UIViewAnimationOptionCurveEaseIn
                                        animations:^{
                                          
                                          self.center = CGPointMake(self.center.x, self.center.y);
                                          
                                          CGAffineTransform transform  = CGAffineTransformMakeScale(1.0, 1.0);
                                          // transform = CGAffineTransformRotate(transform, kDegreesToRadian(90));
                                          self.transform = transform;
                                          // Commit the changes
                                          [UIView commitAnimations];
                                        }completion:^(BOOL finished){
                                          if (finished) {
                                            [UIView animateWithDuration:duration
                                                                  delay:0
                                                                options:UIViewAnimationOptionCurveEaseIn
                                                             animations:^{
                                                               
                                                               CGAffineTransform transform  = CGAffineTransformIdentity;
                                                               self.transform = transform;
                                                               
                                                               // Commit the changes
                                                               [UIView commitAnimations];
                                                             }completion:^(BOOL finished){
                                                               if (finished) {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:kTranslationDone object:nil];
                                                               }
                                                             }];
                                          }
                                        }];
                       
                     }
                     
                   }];
}


@end
