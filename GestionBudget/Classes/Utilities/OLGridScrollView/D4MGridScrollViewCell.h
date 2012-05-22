//
//  D4MGridScrollViewCell.h
//  CommonD4M
//
//  Created by Florent Maitre on 26/09/11.
//  Copyright 2011 France Télécom. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *	@brief	cellule dans une D4MGridScrollView
 */
@interface D4MGridScrollViewCell : UIView
{
    // Bouton supprimer
    UIImageView * editingAccessoryView;
    
    BOOL isEditing;
}

/** Bouton supprimer */
@property(nonatomic, readonly) UIImageView * editingAccessoryView;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@end

/** @endcond */