//
//  ContactGridViewController+RotateSingleViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "ContactGridViewController+RotateSingleViewController.h"
#import "UIView+Rotation.h"
#import "SingleContactViewController.h"

@implementation ContactGridViewController (RotateSingleViewController)

- (void)setGridContactViewControllerCenter{
  int width = self.view.frame.size.width;
  int padding = floor(((width / NB_COLUMNS) - SUBVIEW_WIDTH) / NB_COLUMNS);
  
  int row = 0;
  int column = 0;
  
  for (int i = 0; i < [self.testArray count]; i++) {
    row = floor(i / NB_COLUMNS);
    column = i % NB_COLUMNS;
    SingleContactViewController *controller = [self.testArray objectAtIndex:i];
    int x = (SUBVIEW_WIDTH + padding) * column + (padding + SUBVIEW_WIDTH / 2);
    int y = (41 + padding + SUBVIEW_HEIGHT / 2) + (SUBVIEW_HEIGHT + padding) * row;
    [controller.view setCenter:CGPointMake(x, y)];
  }
}

#define ADD_SUBVIEW_DELAY 0.2
- (void)addContactViewControllersToView{
  [self setGridContactViewControllerCenter];
  for (SingleContactViewController *controller in self.testArray) {
    RLLogDebug(@"%@", controller);
    [controller defineUI];
    // [controller.view setAlpha:0];
    
    [self.view addSubview:controller.view];
    [controller.view rotateToUpFromXAxisView:M_PI_2 during:0];
  }
  
}

- (void)revealContactViewControllersThroughRotation{
  for (SingleContactViewController *controller in self.testArray) {
    RLLogDebug(@"%@", controller);
    // [controller.view setAlpha:1];
    // [controller.view rotateDuring:5 curve:0 radians:M_PI_2];
    // [controller.view rotateToUpFromXAxisView:0 during:5];
  }
}

- (void)hideContactViewControllersThroughRotation{
  for (SingleContactViewController *controller in self.testArray) {
    RLLogDebug(@"%@", controller);
    // [controller.view setAlpha:0];
    // [controller.view rotateDuring:5 curve:0 radians:M_PI_2];
    [controller.view rotateToDownFromXAxisView:M_PI_2 during:5];
  }
}

@end
