//
//  UIView+ShadowAddition.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 07/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "UIView+ShadowAddition.h"


@implementation UIView (ShadowAddition)

/**
 Puts an outer shadow on the view.
 @author : Rémi Lavedrine
 @date : 14/03/2011
 @remarks : (facultatif)
 */
- (void)makeGradientOnView:(UIView *)view{
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 3.2)
	{
		//turning off bounds clipping allows the shadow to extend beyond the rect of the view
		[view setClipsToBounds:NO];
		
		//the colors for the gradient.  highColor is at the top, lowColor as at the bottom
		UIColor * highColor = [UIColor colorWithWhite:1.000 alpha:1.000];
		UIColor * lowColor = [UIColor colorWithRed:0.851 green:0.859 blue:0.867 alpha:1.000];
		
		//The gradient, simply enough.  It is a rectangle
		CAGradientLayer * gradient = [CAGradientLayer layer];
		[gradient setFrame:[view bounds]];
		[gradient setColors:[NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil]];
		
		//[gradient setStartPoint:CGPointMake(0, 0)];
		//[gradient setEndPoint:CGPointMake(view.frame.size.width, 0)];
		
		//the rounded rect, with a corner radius of 6 points.
		//this *does* maskToBounds so that any sublayers are masked
		//this allows the gradient to appear to have rounded corners
		CALayer * roundRect = [CALayer layer];
		[roundRect setFrame:[view bounds]];
		[roundRect setCornerRadius:6.0f];
		[roundRect setMasksToBounds:YES];
		[roundRect addSublayer:gradient];
		
		//add the rounded rect layer underneath all other layers of the view
		[[view layer] insertSublayer:roundRect atIndex:0];
		
		//set the shadow on the view's layer
		[[view layer] setShadowColor:[[UIColor blackColor] CGColor]];
		[[view layer] setShadowOffset:CGSizeMake(0, 4)];
		[[view layer] setShadowOpacity:0.6];
		[[view layer] setShadowRadius:5.0];
  }
  
}

- (void)addOuterShadow{
  [self makeGradientOnView:self];
}



@end
