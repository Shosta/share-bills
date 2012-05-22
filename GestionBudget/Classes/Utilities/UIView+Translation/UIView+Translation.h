//
//  UIView+Translation.h
//  OrangeEtMoi
//
//  Created by Rémi Lavedrine on 10/02/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Translation)
- (void)translateBounceToX:(NSInteger)tx curve:(int)curve during:(NSTimeInterval)duration;
- (void)translateToX:(NSInteger)tx Y:(NSInteger)ty curve:(int)curve during:(NSTimeInterval)duration;
- (void)translateToX:(NSInteger)tx Y:(NSInteger)ty during:(NSTimeInterval)duration;
- (void)translateToInitialPositionDuring:(NSTimeInterval)duration;

- (void)translateAndPulseToX:(NSInteger)tx Y:(NSInteger)ty during:(NSTimeInterval)duration;
- (void)translateAndPulseToInitialPositionDuring:(NSTimeInterval)duration;
@end
