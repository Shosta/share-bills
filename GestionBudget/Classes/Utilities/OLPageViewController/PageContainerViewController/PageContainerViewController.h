//
//  PresentationContainerViewController.h
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContainerViewControllerDatasource.h"
#import "PageContainerViewControllerDelegate.h"
#import "PageViewController.h"


@interface PageContainerViewController : UIViewController {
    
@private
  NSInteger pageTotalNumber_;
  NSMutableArray *pageViewControllers_;
  
  NSInteger pageViewControllerDefaultWidth_;
  NSInteger pageViewControllerDefaultHeight_;
  
  BOOL animatePaging_;
  float animateDuration_;
  
	id pageContainerDataSource_;
	id pageContainerDelegate_;
  BOOL stopAnimation_;
}

@property (assign) 	id pageContainerDataSource;
@property (assign) 	id pageContainerDelegate;

// Draw content on view
- (void)addPageViewControllerOnContainerFromContactIndex:(NSInteger)index;
- (void)removeLastPageViewOnContainer;

// View lifecycle
- (void)viewReload;

// Accessors
- (BOOL)animatePaging;
- (float)animateDuration;
- (void)setAnimatePaging:(BOOL)animatePaging;
- (void)setAnimateDuration:(float)animateDuration;

@end
