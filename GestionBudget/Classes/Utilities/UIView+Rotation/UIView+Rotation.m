//
//  UIView+Rotation.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "UIView+Rotation.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation UIView (Rotation)

// Our conversion definition
#define DEGREES_TO_RADIANS(degrees) (degrees / 180.0 * M_PI)

- (void)rotateDuring:(NSTimeInterval)duration 
              curve:(int)curve 
            degrees:(CGFloat)degrees
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:duration];
  
  //[self.layer setValue:[NSNumber numberWithInt:3.14159] forKeyPath:@"transform.rotation.x"];
  [self.layer setValue:[NSNumber numberWithInt:DEGREES_TO_RADIANS(degrees)] forKeyPath:@"transform.rotation.x"];

  [UIView commitAnimations];
}


- (void)rotateDuring:(NSTimeInterval)duration 
               curve:(int)curve 
             radians:(CGFloat)radians
{
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationRepeatAutoreverses:NO];
  [UIView setAnimationRepeatCount:0];
  
  // [self.layer setValue:[NSNumber numberWithFloat:radians] forKeyPath:@"transform.rotation.x"];
  self.layer.transform = CATransform3DMakeRotation(radians, 1.0f, 0.0f, 0.0f);
  
  [UIView commitAnimations];
  
  /*
  CALayer* layer = someView.layer;
  CABasicAnimation* animation;
  animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  
  animation.fromValue = [NSNumber numberWithFloat:0.0 * M_PI];
  animation.toValue = [NSNumber numberWithFloat:1.0 * M_PI];
  
  animation.duration = 1.0;
  animation.cumulative = YES;
  animation.repeatCount = 1;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  
  [layer addAnimation:rotationAnimation forKey:@"transform.rotation.z"];
*/
}

-(void)rotateToUpFromXAxisView:(CGFloat)radians during:(NSTimeInterval)duration{	
	NSLog(@"On fait une rotation vers le haut selon l'axe des X de la vue.");
	CAKeyframeAnimation *rotationToUpFromXAxis = [CAKeyframeAnimation animation];
	
	rotationToUpFromXAxis.values = [NSArray arrayWithObjects:
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 1.0f, 0.0f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(radians/2, 1.0f, 0.0f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(radians, 1.0f, 0.0f, 0.0f)],
                                  nil];
	
	
	rotationToUpFromXAxis.duration = duration;
	rotationToUpFromXAxis.delegate = self;
	
	[[self layer] addAnimation:rotationToUpFromXAxis forKey:@"transform"];
	
	self.layer.transform = CATransform3DMakeRotation(M_PI/2, 1.0f, 0.0f, 0.0f);
	
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationDuration: duration];
	
	[UIView commitAnimations];
}//rotateToUpFromXAxisView

-(void)rotateToDownFromXAxisView:(CGFloat)radians during:(NSTimeInterval)duration{	
	NSLog(@"On fait une rotation vers le bas selon l'axe des X de la vue.");
	CAKeyframeAnimation *rotationToUpFromXAxis = [CAKeyframeAnimation animation];
	
	rotationToUpFromXAxis.values = [NSArray arrayWithObjects:
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 1.0f, 0.0f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(radians/2, 1.0f, 0.0f, 0.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeRotation(radians, 1.0f, 0.0f, 0.0f)],
                                  nil];
	
	
	rotationToUpFromXAxis.duration = duration;
	rotationToUpFromXAxis.delegate = self;
	
	[[self layer] addAnimation:rotationToUpFromXAxis forKey:@"transform"];
	
	self.layer.transform = CATransform3DMakeRotation(radians, 1.0f, 0.0f, 0.0f);
	
	[UIView beginAnimations:nil context: nil];
	[UIView setAnimationDuration: duration];
	
	[UIView commitAnimations];	
}//rotateToDownFromXAxisView

@end
