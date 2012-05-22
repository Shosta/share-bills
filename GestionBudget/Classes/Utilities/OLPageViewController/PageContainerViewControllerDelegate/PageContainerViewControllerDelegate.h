//
//  PresentationContainerViewControllerDelegate.h
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PageContainerViewControllerDelegate

@required

@optional
- (NSInteger)pageContainerController:(PageContainerViewController *)pageController widthForPageControllerAtIndexPath:(NSIndexPath *)indexPath; 


@end
