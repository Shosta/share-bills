//
//  Page.m
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import "Page.h"


@implementation Page


#pragma mark -
#pragma mark Object life cycle

- (id)init{
  self = [super init];
  if (self) {
    pageName_ = [[NSString alloc] init];
    pageThumbnail_ = [[UIImage alloc] init];
  }
  return self;
}

- (id)initWithName:(NSString *)name thumbnail:(NSData *)thumbnail{
  self = [super init];
  if (self) {
    pageName_ = [[NSString alloc] initWithString:name];
    pageThumbnail_ = [[UIImage alloc] initWithData:thumbnail];
  }
  return self;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc{
  [pageName_ release];
  [pageThumbnail_ release];
  
  [super dealloc];  
}


#pragma mark -
#pragma mark Accessors

- (NSString *)pageName{
  return pageName_;
}

- (void)setPageName:(NSString *)pageName{
  pageName_ = pageName;
}
                    
- (UIImage *)pageThumbnail{
  return pageThumbnail_;
}

- (void)setPageThumbnail:(UIImage *)pageThumbnail{
  pageThumbnail_ = [[pageThumbnail retain] autorelease];
}


@end
