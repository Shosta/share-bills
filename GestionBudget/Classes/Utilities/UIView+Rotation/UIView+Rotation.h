//
//  UIView+Rotation.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotation)

- (void)rotateDuring:(NSTimeInterval)duration 
               curve:(int)curve 
             degrees:(CGFloat)degrees;
- (void)rotateDuring:(NSTimeInterval)duration 
               curve:(int)curve 
             radians:(CGFloat)radians;

-(void)rotateToUpFromXAxisView:(CGFloat)radians during:(NSTimeInterval)duration;
-(void)rotateToDownFromXAxisView:(CGFloat)radians during:(NSTimeInterval)duration;

@end
