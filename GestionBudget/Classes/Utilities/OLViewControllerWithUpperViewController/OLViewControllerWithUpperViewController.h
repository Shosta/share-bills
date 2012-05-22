//
//  OLViewControllerWithUpperViewController.h
//  OLDraggingDemo
//
//  Created by Rémi LAVEDRINE on 06/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OLViewControllerWithUpperViewController : UIViewController {
  
  UIViewController *upperViewController_;
  int revealWidth_;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil upperViewController:(UIViewController *)viewController revealWidth:(int)revealWidth;

- (void)revealViewToRightWithBounce;
- (void)hideViewToLeftWithBounce;


// Accessors
- (UIViewController *)upperViewController;
- (int)revealWidth;
@end

@interface OLViewControllerWithUpperViewController (ProtectedMethods)

// Firing actions at the beginning and end of the upper view scrolling
- (void)lowerViewWillAppear;
- (void)lowerViewDidAppear;
- (void)lowerViewWillDisappear;
- (void)lowerViewDidDisappear;


@end