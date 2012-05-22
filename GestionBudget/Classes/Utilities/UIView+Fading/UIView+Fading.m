//
//  UIView+Fading.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIView+Fading.h"

@implementation UIView (Fading)

- (void)fadeInDuring:(NSNumber *)delay{
  /**
   [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:[delay floatValue]];
  [self setAlpha:0];
  [UIView commitAnimations];
  */
  
  [UIView animateWithDuration:[delay floatValue]
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     
                     [self setAlpha:0];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                   
                   }];

}

- (void)fadeIn{
  [self fadeInDuring:[NSNumber numberWithFloat:0.5]];
}

- (void)fadeOutDuring:(NSNumber *)delay{
  /**
   [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:[delay floatValue]];
  [self setAlpha:1];
  [UIView commitAnimations];
  */
  
  [UIView animateWithDuration:[delay floatValue]
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     
                     [self setAlpha:1];
                     
                     // Animate squash
                   }completion:^(BOOL finished){
                     
                   }];

}

- (void)fadeOut{
  [self fadeOutDuring:[NSNumber numberWithFloat:0.5]];
}

- (void)addSubview:(UIView *)view througFadingDuring:(NSTimeInterval)duration{
  [view setAlpha:0];
  [self addSubview:view];
  [view fadeOutDuring:[NSNumber numberWithFloat:duration]];
}

@end
