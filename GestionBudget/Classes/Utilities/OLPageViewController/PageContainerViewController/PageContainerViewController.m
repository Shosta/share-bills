//
//  PresentationContainerViewController.m
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "PageContainerViewController.h"
#import "Page.h"
#import "NSMutableArray+QueueAdditions.h"
#include <sys/socket.h> 
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>


@implementation PageContainerViewController

@synthesize pageContainerDataSource = pageContainerDataSource_;
@synthesize pageContainerDelegate = pageContainerDelegate_;

#pragma mark -
#pragma mark Animation management

- (NSInteger)getNextAnimatedPositionFromCurrentPosition{
  int currentOffsetX = [(UIScrollView *)self.view contentOffset].x;
  int contentSizeWidth = [(UIScrollView *)self.view contentSize].width;
  
  if ( currentOffsetX == 0 ) {
    return 1;
  }
  if ( currentOffsetX == (contentSizeWidth - pageViewControllerDefaultWidth_) ) {
    return 0;
  }
  
  // RLLogDebug(@"%d; %d", contentSizeWidth, (currentOffsetX / pageViewControllerDefaultWidth_) + 1);
  return (currentOffsetX / pageViewControllerDefaultWidth_) + 1;
}

- (void)scrollToNextPosition{
  if ( !stopAnimation_ ) {
    int nextAnimatedPosition = [self getNextAnimatedPositionFromCurrentPosition];
    BOOL animated = YES;
    /*
     if (nextAnimatedPosition == 0) {
     animated = NO;
     }
     */
    [(UIScrollView  *)self.view scrollRectToVisible:CGRectMake(nextAnimatedPosition * pageViewControllerDefaultWidth_, 0, pageViewControllerDefaultWidth_, pageViewControllerDefaultHeight_) animated:animated];
    
    [self performSelector:@selector(scrollToNextPosition) withObject:nil afterDelay:animateDuration_];
  }
}


#pragma mark -
#pragma mark Populate PageViewContainer

- (NSInteger)getPageNumber{
  if ( [pageContainerDataSource_ respondsToSelector:@selector(numberOfPageInPageContainerController)] ) {
		return [pageContainerDataSource_ numberOfPageInPageContainerController];
	}//if
  
  return 0;
}

- (PageViewController *)createPageViewControllerFromDataSourceAtIndex:(NSInteger)index {
  Page *page = [pageContainerDataSource_ pageContainerController:self pageForPageControllerAtIndex:index];
  
  PageViewController *pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil];
  RLLogDebug(@"[PageContainerViewController::createPageViewControllerFromDataSourceAtIndex] %@", [page pageName]);
  [pageViewController setNameLabelText:[page pageName]];
  [pageViewController setThumbnailImage:[page pageThumbnail]];
  // PageViewController *pageViewController = [[PageViewController alloc] initWithNibName:@"PageViewController" bundle:nil nameLabel:[page pageName] thumbnailImage:[page pageThumbnail]]; 
  
  return [pageViewController autorelease];
}

- (void)removeAllSubviewsFromSuperview{
  if (pageViewControllers_ != nil && [pageViewControllers_ count] > 0) {
    [pageViewControllers_ removeAllObjects];
  }
  for ( UIView *view in [self.view subviews] ) {
    [view removeFromSuperview];
  }
  [self.view removeFromSuperview];
  
}

- (void)populatePagesArray{
  if ( [pageContainerDataSource_ respondsToSelector:@selector(numberOfPageInPageContainerController)] ) {
    pageTotalNumber_ = [pageContainerDataSource_ numberOfPageInPageContainerController];
	}//if
  
  [self removeAllSubviewsFromSuperview];
  for (int currentIndex = 0; currentIndex < pageTotalNumber_; currentIndex++) {
    PageViewController *pageViewController = [self createPageViewControllerFromDataSourceAtIndex:currentIndex];
    [pageViewControllers_ addObject:pageViewController];
  }
}


#pragma mark -
#pragma mark Draw content on view

- (void)setContainerContentSize{
  // RLLogDebug(@"Content Size : %d", [self getPageNumber] * pageViewControllerDefaultWidth_);
  [(UIScrollView  *)self.view setContentSize:CGSizeMake([self getPageNumber] * pageViewControllerDefaultWidth_, pageViewControllerDefaultHeight_)];
}

- (CGSize)containerContentSize{
  // RLLogDebug(@"Content Size : %d", [self getPageNumber] * pageViewControllerDefaultWidth_);
  return [(UIScrollView  *)self.view contentSize];
}

- (void)addPageViewControllerOnContainer{
  int i = 0;
  for (PageViewController *currentController in pageViewControllers_) {
    [currentController.view setFrame:CGRectMake(i * pageViewControllerDefaultWidth_, 0, pageViewControllerDefaultWidth_, pageViewControllerDefaultHeight_)];
    [self.view addSubview:currentController.view];
    [currentController release];
    i++;
  }
}

- (void)addPageViewControllerOnContainerFromContactIndex:(NSInteger)index{
  PageViewController *pageViewController = [self createPageViewControllerFromDataSourceAtIndex:index];
  [pageViewController.view setFrame:CGRectMake([self containerContentSize].width, 0, pageViewControllerDefaultWidth_, pageViewControllerDefaultHeight_)];
  [self.view addSubview:pageViewController.view];
  // [pageViewController release];
}

- (void)removeLastPageViewOnContainer{
  [[(PageViewController *)[pageViewControllers_ lastObject] view] removeFromSuperview];
  [pageViewControllers_ removeLastObject];
}


#pragma mark -
#pragma mark Object life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    pageTotalNumber_ = 0;
    pageViewControllers_ = [[NSMutableArray alloc] initWithCapacity:0];
    
    pageViewControllerDefaultWidth_ = 150;
    pageViewControllerDefaultHeight_ = 50;
    
    animatePaging_ = NO;
    animateDuration_ = 2.0f;
    stopAnimation_ = NO;
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
  // [pageViewControllers_ release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark View lifecycle

- (void)startAnimation{
  if (animatePaging_) {
    stopAnimation_ = NO;
    [self performSelector:@selector(scrollToNextPosition) withObject:nil afterDelay:animateDuration_];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self populatePagesArray];
  
  [self setContainerContentSize];
  [self.view setFrame:CGRectMake(0, 0, pageViewControllerDefaultWidth_, pageViewControllerDefaultHeight_)];
  [self addPageViewControllerOnContainer];
  
  [self startAnimation];
}

- (void)viewReload{
  // [pageViewControllers_ setArray:nil];
  [self populatePagesArray];
  [self setContainerContentSize];
  [self addPageViewControllerOnContainer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Accessors

- (BOOL)animatePaging{
  return animatePaging_;
}

- (float)animateDuration{
  return animateDuration_;
}

- (void)setAnimatePaging:(BOOL)animatePaging{
  animatePaging_ = animatePaging;
}

- (void)setAnimateDuration:(float)animateDuration{
  animateDuration_ = animateDuration;
}


@end
