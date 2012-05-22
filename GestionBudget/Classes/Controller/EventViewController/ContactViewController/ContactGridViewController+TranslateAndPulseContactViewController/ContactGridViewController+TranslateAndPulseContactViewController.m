//
//  ContactGridViewController+TranslateAndPulseContactViewController.m
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 10/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import "ContactGridViewController+TranslateAndPulseContactViewController.h"
#import "SingleContactViewController.h"
#import "UIView+Translation.h"
#import "UIView+Pulse.h"
#import "UIView+Fading.h"

@implementation ContactGridViewController (TranslateAndPulseContactViewController)

/**
 @brief Set the center for each Contact ViewController on the initial Stack.
 @author : Rémi Lavedrine
 @date : 06/04/2012
 @remarks : (facultatif)
 */
- (void)setInitialCenterForContactViewControllers{
  int x = thumbnailImageViewLocationOnWindow.x;
  int y = thumbnailImageViewLocationOnWindow.y;
  for (SingleContactViewController *controller in self.testArray) {
    [controller.view setCenter:CGPointMake(x, y)];
    
    x = x + ADD_SUBVIEW_X_PADDING;
    y = y + ADD_SUBVIEW_Y_PADDING;
  }
}

/**
 @brief Move all Contact ViewController from its original position to its final position. 
 @author : Rémi Lavedrine
 @date : 06/04/2012
 @remarks : (facultatif)
 */
#define PADDING 6
- (void)moveAllContactViewControllerToFinalPosition{
  if ( !contactsViewControllerAreOnFinalPosition ) {
    int x = 0;
    int y = 0;
    
    int width = self.view.frame.size.width;
    int padding = floor(((width / NB_COLUMNS) - SUBVIEW_WIDTH) / NB_COLUMNS);
    
    int row = 0;
    int column = 0;
    
    for (int i = 0; i < [self.testArray count]; i++) {
      x = ADD_SUBVIEW_X_PADDING + SUBVIEW_WIDTH/2 - thumbnailImageViewLocationOnWindow.x;
      y = INITIAL_HEIGHT + SUBVIEW_HEIGHT/2 - thumbnailImageViewLocationOnWindow.y;
      
      row = floor(i / NB_COLUMNS);
      column = i % NB_COLUMNS;
      SingleContactViewController *controller = [self.testArray objectAtIndex:i];
      x = x + (SUBVIEW_WIDTH + padding) * column - ADD_SUBVIEW_X_PADDING * i;
      y = y + INITIAL_HEIGHT +  (SUBVIEW_HEIGHT + padding) * row - ADD_SUBVIEW_Y_PADDING * i;
      [controller.view translateAndPulseToX:x Y:y during:TRANSLATION_DELAY + (DELAY * i)];
      
    }
    contactsViewControllerAreOnFinalPosition = YES;
  }
}

/**
 @brief Move all Contact ViewController from its final position to its original position. 
 @author : Rémi Lavedrine
 @date : 06/04/2012
 @remarks : (facultatif)
 */
- (void)moveAllContactViewControllerToInitialPosition{
  /** If you want simple pulse and then removeSuperView.
   int i = 0;
   for (SingleContactViewController *controller in self.testArray) {
   [controller.view translateAndPulseToInitialPositionDuring:TRANSLATION_DELAY + (DELAY * i)];
   i++;
   }
   */
  
  /** If you want pulse and stack recreation and then removeSuperView.
   */
  int x = 0;
  int y = 0;
  
  int width = self.view.frame.size.width;
  int padding = floor(((width / NB_COLUMNS) - SUBVIEW_WIDTH) / NB_COLUMNS);
  
  int row = 0;
  int column = 0;
  
  for (int i = 0; i < [self.testArray count]; i++) {
    x = ADD_SUBVIEW_X_PADDING + SUBVIEW_WIDTH/2 - thumbnailImageViewLocationOnWindow.x;
    y = INITIAL_HEIGHT + SUBVIEW_HEIGHT/2 - thumbnailImageViewLocationOnWindow.y;
    
    row = floor(i / NB_COLUMNS);
    column = i % NB_COLUMNS;
    SingleContactViewController *controller = [self.testArray objectAtIndex:i];
    x = x + (SUBVIEW_WIDTH + padding) * column - ADD_SUBVIEW_X_PADDING * i;
    y = y + INITIAL_HEIGHT +  (SUBVIEW_HEIGHT + padding) * row - ADD_SUBVIEW_Y_PADDING * i;
    [controller.view translateAndPulseToX:-x Y:-y during:TRANSLATION_DELAY + (DELAY * i)];
    
  }
  contactsViewControllerAreOnFinalPosition = NO;
}

/**
 @brief Create a stack of contacts (SingeContactViewController) from an array of SingleContactViewControllerObject.
 @author : Rémi Lavedrine
 @date : 06/04/2012
 @remarks : (facultatif)
 */
- (void)createContactsStack{
  [self setInitialCenterForContactViewControllers];
  int i = 0;
  for (SingleContactViewController *controller in self.testArray) {
    RLLogDebug(@"%@", controller);
    [controller defineUI];
    [controller.view setAlpha:0];
    [self.view addSubview:controller.view];
    NSNumber *n = [NSNumber numberWithFloat:(ADD_SUBVIEW_DELAY * i)];
    [controller.view performSelector:@selector(fadeOutDuring:) withObject:n afterDelay:0];
    i++;
  }
}

/**
 @brief Remove all SingleViewControllers describing the contacts from the superView.
 @author : Rémi Lavedrine
 @date : 10/04/2012
 @remarks : (facultatif)
 */
- (void)removeContactsStacks{
  int i = 0;
  for (SingleContactViewController *controller in self.testArray) {
    NSNumber *n = [NSNumber numberWithFloat:(REMOVE_SUBVIEW_DELAY * i)];
    [controller.view fadeOutDuring:n];
    [controller.view performSelector:@selector(removeFromSuperview) withObject:0 afterDelay:(REMOVE_SUBVIEW_DELAY * i)];
    
    i++;
  }
}

@end
