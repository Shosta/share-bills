//
//  Page.h
//  OLViewPageController
//
//  Created by Rémi LAVEDRINE on 15/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Page : NSObject {
    
@private
  NSString *pageName_;
  UIImage *pageThumbnail_;
}


// Object life cycle
- (id)initWithName:(NSString *)name thumbnail:(NSData *)thumbnail;


// Accessors
- (NSString *)pageName;
- (void)setPageName:(NSString *)pageName;
- (UIImage *)pageThumbnail;
- (void)setPageThumbnail:(UIImage *)pageThumbnail;

@end
