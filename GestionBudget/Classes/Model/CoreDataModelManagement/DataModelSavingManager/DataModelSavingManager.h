//
//  DataModelSavingManager.h
//  GestionBudget
//
//  Created by Rémi LAVEDRINE on 09/09/11.
//  Copyright 2011 Orange Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataModelSavingManager : NSObject {
    
  @private
  BOOL isCurrentlySaving_;
}

+ (DataModelSavingManager *)sharedManager;

- (void)initManager;
- (void)nonConcurrentSaveContext;

@end
