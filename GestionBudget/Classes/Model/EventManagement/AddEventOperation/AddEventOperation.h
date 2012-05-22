//
//  AddEventOperation.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 13/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//
// This class get the event name and perform the creation of the corresponding Managed Object and save it in the Core Data model.
//

#import <Foundation/Foundation.h>


@interface AddEventOperation : NSOperation {
    
  @private
  NSString *eventName_;
  NSData *eventImageData_;
}

- (id)initWithEventName:(NSString *)name eventImageData:(NSData *)imageData;

@end
