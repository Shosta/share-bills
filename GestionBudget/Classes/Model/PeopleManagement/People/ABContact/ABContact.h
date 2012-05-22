//
//  ABContact.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 09/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//
// Describe a contact from the device Adress Book.
// 

#import <Foundation/Foundation.h>
#import "People.h"

@interface ABContact : People {
    
}

- (NSData *)getContactThumbnailData;

@end
