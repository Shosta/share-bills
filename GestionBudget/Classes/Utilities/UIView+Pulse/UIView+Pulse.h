//
//  UIView+Pulse.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Pulse)
- (void)pulseDuringTimeInterval:(NSTimeInterval)duration;
- (void)pulseDuring:(NSNumber *)duration;
@end
