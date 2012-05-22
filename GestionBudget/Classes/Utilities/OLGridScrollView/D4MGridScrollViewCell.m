//
//  D4MCarouselItemContainerView.m
//  CommonD4M
//
//  Created by Florent Maitre on 26/09/11.
//  Copyright 2011 France Télécom. All rights reserved.
//

#import "D4MGridScrollViewCell.h"

@implementation D4MGridScrollViewCell

@synthesize editingAccessoryView;

#pragma mark -
#pragma mark Inherited methods


/**
 *	@author	Florent Maitre
 *
 *	@date	26/09/2011
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Accessoire
        editingAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"D4MCarouselViewDelete.png"]];
        editingAccessoryView.alpha = 0.0;
        [self addSubview:editingAccessoryView];
        
        isEditing = NO;
        
    }
    return self;
}


/**
 *	@author	Florent Maitre
 *
 *	@date	26/09/2011
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (editingAccessoryView)
    {
        // Frame de l'accessory
        // On essaye de centrer l'accessory sur le coin haut droit de l'élément
        CGFloat accessoryCenterX = editingAccessoryView.bounds.size.width / 2;
        CGFloat accessoryCenterY = editingAccessoryView.bounds.size.height / 2;
       
        editingAccessoryView.center = CGPointMake(accessoryCenterX, accessoryCenterY);
        [self bringSubviewToFront:editingAccessoryView];
    }
}


/**
 *	@author	Florent Maitre
 *
 *	@date	26/09/2011
 */
- (void)dealloc
{
    [editingAccessoryView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods


/**
 *	@brief	Configure le mode édition de la vue container
 *
 *	@param 	editing 	Edition
 *	@param 	animated 	Animation
 *
 *	@author	Florent Maitre
 *
 *	@date	26/09/2011
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    isEditing = editing;
    
    if (editingAccessoryView)
    {
        if(animated)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
        }
        
        editingAccessoryView.alpha = editing ? 1.0f : 0.0f;
        
        if(animated)
        {
            [UIView commitAnimations];
        }
    }
    [self setNeedsLayout];
    
}

@end