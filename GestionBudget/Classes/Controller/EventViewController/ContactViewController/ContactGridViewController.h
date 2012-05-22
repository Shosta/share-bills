//
//  ContactViewController.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 06/04/12.
//  Copyright (c) 2012 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactGridViewController : UIViewController{
  NSMutableArray *testArray;
  BOOL contactsViewControllerAreOnFinalPosition;
  CGPoint thumbnailImageViewLocationOnWindow;
}

@property (nonatomic, retain) NSMutableArray *testArray;
@property (retain, nonatomic) IBOutlet UIButton *dismissViewButton;

#define NB_COLUMNS 3

#define SUBVIEW_WIDTH 100
#define SUBVIEW_HEIGHT 100
#define INITIAL_HEIGHT 41
#define ADD_SUBVIEW_X_PADDING 3
#define ADD_SUBVIEW_Y_PADDING 3
#define TRANSLATION_DELAY 0.05
#define SUPERVIEW_FADEOUT_DURATION 0.2

- (void)displayContactsView:(CGPoint)touchOrigin;

// Accessors
- (void)setContactArray:(NSArray *)contactArray;

@end
