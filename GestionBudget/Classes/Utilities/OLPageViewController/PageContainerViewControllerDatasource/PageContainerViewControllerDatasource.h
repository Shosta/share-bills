//
//  PresentationContainerViewControllerDatasource.h
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Page;
@class PageContainerViewController;

@protocol PageContainerViewControllerDatasource

@required
- (NSInteger)numberOfPageInPageContainerController;
- (Page *)pageContainerController:(PageContainerViewController *)pageController pageForPageControllerAtIndex:(NSInteger)index;

@optional

@end
