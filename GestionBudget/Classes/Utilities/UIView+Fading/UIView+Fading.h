//
//  UIView+Fading.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Fading)

- (void)fadeInDuring:(NSNumber *)delay;
- (void)fadeIn;
- (void)fadeOutDuring:(NSNumber *)delay;
- (void)fadeOut;
- (void)addSubview:(UIView *)view througFadingDuring:(NSTimeInterval)duration;

@end
