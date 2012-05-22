//
//  D4MGridScrollView.h
//  CommonD4MExamples
//
//  Created by Gil Nakache on 17/10/11.
//  Copyright (c) 2011 France Télécom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D4MGridScrollViewCell.h"

@protocol D4MGridScrollViewDataSource;
@protocol D4MGridScrollViewDelegate;

/**
 *	@brief	Scrollview affichant une grille de cellules
 */
@interface D4MGridScrollView : UIScrollView <UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    /** source de données
     */
    id <D4MGridScrollViewDataSource> dataSource;
    
    /** delegate
     */
    id <D4MGridScrollViewDelegate> gridDelegate;
    
    /** vue conteneur principale
     */
    UIView *cellContainerView;
    
@private
    
    /** taille d'une cellule
     */
    CGSize cellSize;
    
    /** nombre de lignes
     */
    NSInteger numberOfRowsInGrid;
    
    /** nombre de colonnes
     */
    NSInteger numberOfColumnsInGrid;
    
    /** nombre de cellules
     */
    NSInteger numberOfCells;
    
    /** set des cellules visibles
     */
    NSMutableDictionary *visibleCells;
    /** set des cellules réutilisables
     */
    NSMutableSet *reusableCells;
    
    /** est on en mode edition
     */
    BOOL isEditing;
    
    /** Animation de suppression en cours
     */
    BOOL isDeleting;
    
    /** Gesture de drag
     */
    UIPanGestureRecognizer *panGesture;
    
    /** Gesture d'appui long
     */
    UILongPressGestureRecognizer *longPressGesture;
    
    /** cellule en cours de déplacement
     */
    UIView *draggedCell;
    
    /** timer pour l'autoscroll
     */
    NSTimer *autoscrollTimer;
    
    /** stockage de l'offset entre le centre de la cellule déplacée et l'endroit ou le doigt touche la cellule
     */
    CGPoint draggedCellOffsetFromCenter;
    
    /** décalage à appliquer pendant l'autoscroll
     */
    CGPoint contentOffsetToApplyForAutoscroll;
    
    /**  index de départ d'une cellule déplacée
     */
    NSInteger draggedCellIndex;
    
    /** index temporaire d'une cellule déplacée
     */
    NSInteger temporaryDraggedCellIndex;
    
    /** lorsque des cellules sont en cours de déplacement dans la grilles
     */
    BOOL isGridReordering;
    
    /** lorsque l'on relache une cellule
     */
    BOOL isCenteringCell;
    
    NSInteger firstVisibleIndex;
    NSInteger lastVisibleIndex;
}

@property (nonatomic,assign) id <D4MGridScrollViewDelegate>   gridDelegate;
@property (nonatomic,assign) id <D4MGridScrollViewDataSource>   dataSource;
@property (nonatomic,retain) UIView *cellContainerView;

- (void)reloadData;
- (void)redisplay;
- (D4MGridScrollViewCell *)dequeueReusableCells;
- (void)beginEditing;
- (void)endEditing;
- (void)deleteCellAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)insertCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (D4MGridScrollViewCell *)cellAtIndex:(NSInteger)index;

@end


/**
 *	@brief	Protocol pour la source de données de la grille
 */
@protocol D4MGridScrollViewDataSource <NSObject>

@required

- (D4MGridScrollViewCell *)gridScrollView:(D4MGridScrollView *)scrollView cellForIndex:(NSInteger)index;
- (int)numberOfCellsForGridScrollView:(D4MGridScrollView *)scrollView;
- (int)numberOfColumnsForGridScrollView:(D4MGridScrollView *)scrollView;
- (CGSize)cellSizeForGridScrollView:(D4MGridScrollView *)scrollView;

@optional

- (void)gridScrollView:(D4MGridScrollView *)scrollView moveCellAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
- (void)gridScrollView:(D4MGridScrollView *)scrollView commitDeleteForItemAtIndex:(NSInteger)index;

@end

/**
 *	@brief	Protocol pour la source de données de la grille
 */
@protocol D4MGridScrollViewDelegate <NSObject>

@optional
- (void)gridScrollView:(D4MGridScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;
- (void)gridScrollViewDidBeginEdit:(D4MGridScrollView *)scrollView;
@end
