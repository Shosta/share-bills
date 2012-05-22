//
//  D4MGridScrollView.m
//  CommonD4MExamples
//
//  Created by Gil Nakache on 17/10/11.
//  Copyright (c) 2011 France Télécom. All rights reserved.
//

#define kAutoscrollThreshold 30
#define kCellMargin 2
#define kzPositionFront 1000
#define kzPositionBack  500
#define kAlphaDraggedCell   0.8f
#define kAlphaNormalCell    1.0f
#define kScaleDraggedCell   1.2f
#define kEditModePressDuration  0.1f
#define kNormalModePressDuration 0.5f


#import "D4MGridScrollView.h"
#import "D4MGridScrollViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface D4MGridScrollView ()

@property (nonatomic,retain) NSMutableDictionary *visibleCells;
@property (nonatomic,retain) UIView *draggedCell;
@property (nonatomic,retain) UIPanGestureRecognizer *panGesture;
@property (nonatomic,retain) UILongPressGestureRecognizer *longPressGesture;

-(void)addCellAtIndex:(NSInteger)index toRow:(NSInteger)row andCol:(NSInteger)col;
-(NSInteger)rowForIndex:(NSInteger)index;
-(NSInteger)colForIndex:(NSInteger)index;
-(CGPoint)centerOfCellForPoint:(CGPoint)point;
-(NSInteger)currentRowForPoint:(CGPoint)point;
-(NSInteger)currentColForPoint:(CGPoint)point;
-(NSInteger)currentIndexForPoint:(CGPoint)point;
-(CGPoint)centerOfCellForIndex:(NSInteger)index;
-(CGRect)cellFrameForIndex:(NSInteger)index;
-(CGRect)cellPositionForIndex:(NSInteger)index;
-(NSInteger)indexForColumn:(NSInteger)column row:(NSInteger)row;
-(void)performCellShiftIfNecessary;
-(void)centerDraggedCell;
-(void)wobble;

@end

@implementation D4MGridScrollView

@synthesize gridDelegate;
@synthesize dataSource;
@synthesize visibleCells;
@synthesize cellContainerView;
@synthesize draggedCell;
@synthesize panGesture;
@synthesize longPressGesture;

static const CGFloat kWobbleRadians = 1.5f;
static const NSTimeInterval kWobbleTime = 0.04;


#pragma mark Méthodes publiques

/**
 *	@brief	Constructeur *
 *	@param 	frame 	frame *
 *	@return	self
 *	@author	Gil Nakache
 *	@date	17/10/2011
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        isGridReordering = NO;
        isEditing = NO;
        isCenteringCell = NO;
        
        visibleCells = [[NSMutableDictionary alloc] init];
        reusableCells = [[NSMutableSet alloc] init];
        
        cellContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:cellContainerView];
        
        [self setZoomScale:1.0];
        
        firstVisibleIndex = 0;
        lastVisibleIndex = 0;
      
        // detection du passage en mode édition:
        longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        longPressGesture.minimumPressDuration = kNormalModePressDuration;
        [self addGestureRecognizer:longPressGesture];
        
        // détection du dragging
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:singleTapGesture];
        [singleTapGesture release];
        
        [super setDelegate:self];
    }
    return self;
}


/**
 *	@brief	Destructeur
 *	@author	Gil Nakache
 *	@date	17/10/2011
 */
- (void)dealloc
{
    [longPressGesture release];
    [panGesture release];
    [draggedCell release];
    [visibleCells release];
    [reusableCells release];
    [cellContainerView release];
    
    [super dealloc];
}


/**
 *	@brief	Rechargement des données
 *	@author	Gil Nakache
 *	@date	11/08/2011
 */
- (void)reloadData
{
    // Stockage des informations provenant de la datasource au moment du reloadData
    cellSize = [dataSource cellSizeForGridScrollView:self];
    
    numberOfCells = [dataSource numberOfCellsForGridScrollView:self];
    numberOfColumnsInGrid = [dataSource numberOfColumnsForGridScrollView:self];
    numberOfRowsInGrid = ceilf(((numberOfCells *1.0f) / (numberOfColumnsInGrid *1.0f)));
    
    CGSize contentSize = CGSizeMake(cellSize.width*numberOfColumnsInGrid, cellSize.height *numberOfRowsInGrid);
    
    // Calcul de la contentSize et de la taille de la cellContainerView en fonction de la taille et du nombre des cellules
    self.contentSize = contentSize;
    
    [cellContainerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    
    // calcul de l'affichage dans le setNeedsLayout
    [self redisplay];
    
}


/**
 *	@brief	Provoque un recalcul complet de ce qui est visible/non visible
 *	@author	Gil Nakache
 *	@date	17/10/2011
 */
- (void)redisplay
{
    // recyclage de toutes les cellules
    for (UIView *view in [visibleCells allValues]) 
    {
        [reusableCells addObject:view];
        [view removeFromSuperview];
    }
    
    // on supprime les cells reutilisable de la liste des cell visibles
    [visibleCells removeAllObjects];
    
    [self setNeedsLayout];
}


/**
 *	@brief	Affichage des cellule visibles à l'ecran
 *	@author	Gil Nakache
 *	@date	17/10/2011
 */
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    CGRect visibleBounds = [self bounds];
    
    // on calcule les cellules qui sont visibles
    NSInteger maxRow = floorf([cellContainerView frame].size.height / cellSize.height)-1; // this is the maximum possible row
    NSInteger maxCol = floorf([cellContainerView frame].size.width  / cellSize.width)-1;  // and the maximum possible column
    
    NSInteger firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / cellSize.height)-1);
    NSInteger firstNeededCol = MAX(0, floorf(visibleBounds.origin.x / cellSize.width)-1);
    
    NSInteger lastNeededRow  = MIN(maxRow, floorf(CGRectGetMaxY(visibleBounds) / cellSize.height)+1);
    NSInteger lastNeededCol  = MIN(maxCol, floorf(CGRectGetMaxX(visibleBounds) / cellSize.width)+1);
    
    // On recycle les cellules qui ne sont plus visibles
    for (NSNumber *indexNumberForCell in [visibleCells allKeys])
    {
        NSInteger indexOfCell = [indexNumberForCell integerValue];
        NSInteger cellRow = [self rowForIndex:indexOfCell];
        NSInteger cellCol = [self colForIndex:indexOfCell];
        
        if (!((cellRow >= firstNeededRow) && (cellRow <= lastNeededRow) &&
              (cellCol >=firstNeededCol) && (cellCol <= lastNeededCol)))
        {
            D4MGridScrollViewCell *cell = [visibleCells objectForKey:indexNumberForCell];
            
            if (cell != self.draggedCell)
            {
                cell.layer.zPosition = kzPositionBack;
                cell.transform = CGAffineTransformIdentity;
                [reusableCells addObject:cell];
                [cell removeFromSuperview];
                [visibleCells removeObjectForKey:indexNumberForCell];
            }
        }
    }
    
    // iterate through needed rows and columns, adding any tiles that are missing
    for (NSInteger row = firstNeededRow; row <= lastNeededRow; row++) 
    {
        for (NSInteger col = firstNeededCol; col <= lastNeededCol; col++) 
        {
            NSInteger cellIndex = [self indexForColumn:col row:row];
            D4MGridScrollViewCell *cellView = [visibleCells objectForKey:[NSNumber numberWithInteger:cellIndex]];
            
            if (!cellView) 
            {
                // gestion du décallage pendant que l'on drag une cellule
                if (self.draggedCell && (draggedCellIndex!=temporaryDraggedCellIndex))
                {
                    // si l'index original de la cellule 
                    if ((draggedCellIndex <= cellIndex) && (contentOffsetToApplyForAutoscroll.y <0 || contentOffsetToApplyForAutoscroll.x <0))
                    {
                        cellIndex ++;
                    }
                    else if ((draggedCellIndex >= cellIndex) && (contentOffsetToApplyForAutoscroll.y >0|| contentOffsetToApplyForAutoscroll.x >0))
                    {
                        cellIndex --;
                    }
                }
                
                [self addCellAtIndex:cellIndex toRow:row andCol:col];
            }
        }
    }
    
    firstVisibleIndex = [self indexForColumn:firstNeededCol row:firstNeededRow];
    lastVisibleIndex = MIN([self indexForColumn:lastNeededCol row:lastNeededRow],numberOfCells);
    
}

/**
 *	@brief	recyclage des cellules *
 *	@return	une vue recyclée ou nil
 *	@author	Gil Nakache
 *	@date	12/08/2011
 */
- (D4MGridScrollViewCell *)dequeueReusableCells
{
    D4MGridScrollViewCell *cellView = [reusableCells anyObject];
    if (cellView) 
    {
        // permet d'eviter un dealloc lors du removeObject
        [[cellView retain] autorelease];
        [reusableCells removeObject:cellView];
    }
    return cellView;
}

/**
 *	@brief	affichage de la cellule à l'index dans la datasource affiché sur la ligne/col *
 *	@param 	index 	index
 *	@param 	row 	ligne
 *	@param 	col 	colonne
 *	@author	Gil Nakache
 *	@date	07/11/2011
 */
-(void)addCellAtIndex:(NSInteger)index toRow:(NSInteger)row andCol:(NSInteger)col
{
    D4MGridScrollViewCell *cellView = [dataSource gridScrollView:self cellForIndex:index];
    
    // la datasource peut renvoyer nil
    if (cellView)
    {
        cellView.alpha = 1.0f;
        [cellView setEditing:isEditing animated:NO];
        cellView.frame = CGRectMake((col*cellSize.width)+kCellMargin,(row*cellSize.height)+kCellMargin, cellSize.width-(kCellMargin*2), cellSize.height-(kCellMargin*2));
        
        [cellContainerView addSubview:cellView];
        [cellView setNeedsDisplay];
        
        NSInteger cellIndex = [self indexForColumn:col row:row];
        
        [visibleCells setObject:cellView forKey:[NSNumber numberWithInteger:cellIndex]];
        RLLogDebug(@"missing cell: index:%d cellIndex:%d row:%d col:%d",index,cellIndex,row,col);
    }
}

/**
 *	@brief	insertion d'une cellule à un index *
 *	@param 	index 	index de la cellule
 *	@param 	animated 	animé
 *	@author	Gil Nakache
 *	@date	07/11/2011
 */
-(void)insertCellAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!animated)
    {
        [self reloadData];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:
         ^{
             numberOfCells++;
             numberOfRowsInGrid = ceilf(((numberOfCells *1.0f) / (numberOfColumnsInGrid *1.0f)));
             
             CGSize contentSize = CGSizeMake(cellSize.width*numberOfColumnsInGrid, cellSize.height *numberOfRowsInGrid);
             
             // Calcul de la contentSize et de la taille de la cellContainerView en fonction de la taille et du nombre des cellules
             self.contentSize = contentSize;
             
             [cellContainerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
             
             NSInteger row = [self rowForIndex:index];
             NSInteger col = [self colForIndex:index];
             [self addCellAtIndex:index toRow:row andCol:col];
         }];
    }
}

/**
 *	@brief	suppression de la cellule *
 *	@param 	index 	index de la cellule à supprimer
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
- (void)deleteCellAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!animated)
    {
        [self reloadData];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:
         ^{
             isDeleting = YES;
             NSArray *orderedKeys = [[self.visibleCells allKeys] sortedArrayUsingComparator:^(id a, id b) 
                                     { 
                                         return [a compare:b]; 
                                     }]; 
             for (NSNumber *indexNumberOfCell in orderedKeys)
             {
                 NSInteger indexOfCell = [indexNumberOfCell integerValue];
                 D4MGridScrollViewCell *cell = [self.visibleCells objectForKey:indexNumberOfCell];
                 
                 if (indexOfCell == index)
                 {
                     cell.alpha = 0.0f;
                     cell.layer.zPosition = kzPositionBack;
                     cell.transform = CGAffineTransformIdentity;
                     [reusableCells addObject:cell];
                     [cell removeFromSuperview];
                     [self.visibleCells removeObjectForKey:[NSNumber numberWithInteger:index]];
                 }
                 else if (indexOfCell > index)
                 {
                     cell.center = [self centerOfCellForIndex:indexOfCell -1];
                     [self.visibleCells setObject:cell forKey:[NSNumber numberWithInteger:indexOfCell -1]];
                     [self.visibleCells removeObjectForKey:[NSNumber numberWithInteger:indexOfCell]];
                 }
             }
             
             numberOfCells--;
             numberOfRowsInGrid = ceilf(((numberOfCells *1.0f) / (numberOfColumnsInGrid *1.0f)));
             
             CGSize contentSize = CGSizeMake(cellSize.width*numberOfColumnsInGrid, cellSize.height *numberOfRowsInGrid);
             
             // Calcul de la contentSize et de la taille de la cellContainerView en fonction de la taille et du nombre des cellules
             self.contentSize = contentSize;
             
             [cellContainerView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
         }
                         completion:^(BOOL finished) 
         {
             [self setNeedsLayout];
             isDeleting = NO;
         }];
        
    }
}

/**
 *	@brief	renvoie la cellule qui se trouve à l'index passé en paramêtre *
 *	@param 	index 	l'index de la cellule *
 *	@return	la cellule
 *	@author	Gil Nakache
 *	@date	03/11/2011
 */
- (D4MGridScrollViewCell *)cellAtIndex:(NSInteger)index
{
    return [visibleCells objectForKey:[NSNumber numberWithInteger:index]];
}


/**
 *	@brief	activation du mode edition
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
- (void)beginEditing
{
    isEditing = YES;
    longPressGesture.minimumPressDuration = kEditModePressDuration;
    if ([gridDelegate respondsToSelector:@selector(gridScrollViewDidBeginEdit:)])
    {
        [gridDelegate gridScrollViewDidBeginEdit:self];
    }
    
    for (D4MGridScrollViewCell *cell in [self.visibleCells allValues])
    {
        [cell setEditing:YES animated:YES];
    }
    [self wobble];
}

/**
 *	@brief	désactivation du mode édition
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
- (void)endEditing
{
    isEditing = NO;
        longPressGesture.minimumPressDuration = kNormalModePressDuration;
    for (D4MGridScrollViewCell *cell in [self.visibleCells allValues])
    {
        [cell setEditing:NO animated:YES];
    }
    
}

/**
 *	@brief	rafraichissement en cas de scroll
 *	@param 	scrollView 	scrollview en train de scroller
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
}

#pragma mark Méthodes privées

#pragma mark -Gestures

// Permet d'autoriser la gesture de scroll de la scrollview en meme temps que la gesture de drag
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer 
{
    return YES;
}

/**
 *	@brief	permet d'interdire le drag de la scrollview à partir du moment ou l'on commence à dragger une cellule
 *	@param 	gestureRecognizer 	gesture
 *	@return	YES/NO
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // a partir du moment ou l'on commence une gesture de drag, on interdit la gesture de scroll
    if ((gestureRecognizer != panGesture) && (self.draggedCell))
    {
        return NO;
    }
    return YES; 
}

/**
 *	@brief	gestion du tap *
 *	@param 	recognizer 	gesture
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    if (!isDeleting && !isCenteringCell)
    {
        CGPoint tapPoint = [recognizer locationInView:self];
        D4MGridScrollViewCell *touchedCell = nil;
        NSInteger indexOfTappedCell;
        
        for (D4MGridScrollViewCell *cell in [self.visibleCells allValues])
        {
            if (CGRectContainsPoint(cell.frame, tapPoint))
            {
                touchedCell = [cell retain];
                //FIXME optim
                indexOfTappedCell = [self currentIndexForPoint:tapPoint];
                break;
            }
            
        }
        
        if (touchedCell)
        {
            
            // mode édition
            if (isEditing)
            {
                RLLogDebug(@"%f %f",[recognizer locationInView:touchedCell].x,[recognizer locationInView:touchedCell].y);
                if (CGRectContainsPoint(touchedCell.editingAccessoryView.frame, [recognizer locationInView:touchedCell]))
                {
                    if ([dataSource respondsToSelector:@selector(gridScrollView:commitDeleteForItemAtIndex:)])
                    {
                        [dataSource gridScrollView:self commitDeleteForItemAtIndex:indexOfTappedCell];
                    }
                }
            }
            // mode normal
            else
            {
                
                if ([gridDelegate respondsToSelector:@selector(gridScrollView:didSelectItemAtIndex:)])
                {
                    [gridDelegate gridScrollView:self didSelectItemAtIndex:indexOfTappedCell];
                }
                
            } 
            
            [touchedCell release];
        }
    }
    
}

/**
 *	@brief	gestion du drag
 *	@param 	recognizer 	recognizer
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (self.draggedCell && !isCenteringCell)
    {
        switch ([recognizer state])
        {
            case UIGestureRecognizerStateBegan:
            {
                [UIView animateWithDuration:0.1 animations:
                 ^{
                     [self.draggedCell setTransform:CGAffineTransformMakeScale(kScaleDraggedCell, kScaleDraggedCell)];
                     self.draggedCell.alpha = kAlphaDraggedCell;
                     //
                     self.draggedCell.center = CGPointMake([recognizer locationInView:self].x - draggedCellOffsetFromCenter.x,[recognizer locationInView:self].y-draggedCellOffsetFromCenter.y );
                 }];
                break;
            }    
            case UIGestureRecognizerStateChanged:
            {     
                self.draggedCell.center = CGPointMake([recognizer locationInView:self].x - draggedCellOffsetFromCenter.x,[recognizer locationInView:self].y-draggedCellOffsetFromCenter.y );
                
                CGRect visibleBounds = self.bounds;
                CGRect convertedFrame = [self.cellContainerView convertRect:[self.draggedCell frame] toView:self];
                
                
                CGRect intersectionRectangle = CGRectIntersection(visibleBounds, convertedFrame);
                
                // calcul d'un éventuel déplacement de la gridview
                // on recherche si il y a intersection entre la cellule et le bord de l'ecran
                if (!CGRectEqualToRect(intersectionRectangle, self.draggedCell.frame) || CGRectIsNull(intersectionRectangle))
                {
                    float distance;
                    
                    contentOffsetToApplyForAutoscroll = CGPointMake(0, 0);
                    
                    // intersection bord de droite?
                    distance = CGRectGetMaxX(convertedFrame) -CGRectGetMaxX(visibleBounds);
                    if (distance > kAutoscrollThreshold)
                    {
                        contentOffsetToApplyForAutoscroll = CGPointMake((distance-kAutoscrollThreshold)/5.0,0);
                    }
                    
                    // intersection bord de gauche?
                    distance = CGRectGetMinX(visibleBounds) -CGRectGetMinX(convertedFrame);
                    if (distance > kAutoscrollThreshold)
                    {
                        contentOffsetToApplyForAutoscroll = CGPointMake(-(distance-kAutoscrollThreshold)/5.0,0);
                    }
                    
                    // intersection bord du haut?
                    distance = CGRectGetMinY(visibleBounds) -CGRectGetMinY(convertedFrame);
                    if (distance > kAutoscrollThreshold)
                    {
                        contentOffsetToApplyForAutoscroll = CGPointMake(contentOffsetToApplyForAutoscroll.x,-(distance-kAutoscrollThreshold)/5.0);
                    }
                    
                    // intersection bord du bas?
                    distance = CGRectGetMaxY(convertedFrame) - CGRectGetMaxY(visibleBounds);
                    if (distance > kAutoscrollThreshold)
                    {
                        contentOffsetToApplyForAutoscroll = CGPointMake(contentOffsetToApplyForAutoscroll.x,(distance-kAutoscrollThreshold)/5.0);
                    }
                    
                    if (CGPointEqualToPoint(contentOffsetToApplyForAutoscroll, CGPointMake(0, 0)))
                    {
                        [autoscrollTimer invalidate];
                        autoscrollTimer = nil;
                    } 
                    
                    // otherwise create and start timer (if we don't already have a timer going)
                    else if (autoscrollTimer == nil) 
                    {
                        autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                                           target:self 
                                                                         selector:@selector(autoscrollTimerFired:) 
                                                                         userInfo:self.draggedCell
                                                                          repeats:YES];
                    }
                }
                
                [self performCellShiftIfNecessary];
                break;
            }    
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {   
                
                [autoscrollTimer invalidate];
                autoscrollTimer = nil;
                [self centerDraggedCell];         
                break;
            }   
            default:
                break;
                
        }
    }
}

/**
 *	@brief	Gestion de l'appui long
 *	@param 	recognizer 	recognizer
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer
{
    // on ne déclenche pas la gesture d'appui long si on est en cours de scroll
    if ((![self isDragging]) && !isGridReordering && !isDeleting)
    {
        switch ([recognizer state])
        {
            case UIGestureRecognizerStateBegan:
            {
                // passage en mode édition
                if (!isEditing)
                {
                    [self beginEditing];
                }
                
                // Recherche de la cellule déplacée
                for (D4MGridScrollViewCell *cell in [self.visibleCells allValues])
                {
                    // suppression eventuelle
                    if (CGRectContainsPoint(cell.editingAccessoryView.frame, [recognizer locationInView:cell]))
                    {
                        if ([dataSource respondsToSelector:@selector(gridScrollView:commitDeleteForItemAtIndex:)])
                        {
                            [dataSource gridScrollView:self commitDeleteForItemAtIndex:[self currentIndexForPoint:[recognizer locationInView:self]]];
                        }
                        break;
                    } 
                    else if (CGRectContainsPoint(cell.frame, [recognizer locationInView:self]))
                    {
                        draggedCellOffsetFromCenter = CGPointMake([recognizer locationInView:self].x - cell.center.x,[recognizer locationInView:self].y-cell.center.y);
                        self.draggedCell = cell;
                        draggedCellIndex = temporaryDraggedCellIndex = [self currentIndexForPoint:[recognizer locationInView:self]];
                        self.draggedCell.layer.zPosition = kzPositionFront;
                        
                        [UIView animateWithDuration:0.2 animations:
                         ^{
                             cell.transform = CGAffineTransformMakeScale(kScaleDraggedCell, kScaleDraggedCell);
                             self.draggedCell.alpha = kAlphaDraggedCell;
                         }];
                        break;
                    }
                }
                
                
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                if (!autoscrollTimer)
                {
                    [self centerDraggedCell];
                }
                
                break;
            }
            default:
            {
                break;
            }
        }
    }
    
}

/**
 *	@brief	Centrage d'une cellule lorsque celle-ci est relachée
 *	@author	Gil Nakache
 *	@date	25/10/2011
 */
-(void)centerDraggedCell
{
    isCenteringCell = YES;
    
    if (isGridReordering || isDeleting)
    {
        [self performSelector:@selector(centerDraggedCell) withObject:nil afterDelay:0.2f];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:
         ^{
             
             isGridReordering = YES;
             CGPoint center;
             
             NSInteger cellIndex = temporaryDraggedCellIndex;
             
             // on recherche si l'index d'arrivée est supérieur au nombre total d'elements
             if (cellIndex > numberOfCells-1)
             {
                 cellIndex = numberOfCells -1;
                 // Si c'est le cas, alors, on ramene la cellule au dernier element
                 center = [self centerOfCellForIndex:numberOfCells-1];        
             }
             else
             {
                 center = [self centerOfCellForIndex:cellIndex];
             }
             [self.draggedCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
             
             self.draggedCell.center = center;
             self.draggedCell.alpha = 1.0;
             
             // on envoit un message à la datasource pour la prevenir que l'on a déplacé une cellule
             if (([self.dataSource respondsToSelector:@selector(gridScrollView:cellForIndex:)]) && (draggedCellIndex != cellIndex))
             {
                 [self.dataSource gridScrollView:self moveCellAtIndex:draggedCellIndex toIndex:cellIndex];
             }
         } 
                         completion:^(BOOL finished)
         {
             // retour cellule en arriere plan
             self.draggedCell.layer.zPosition = kzPositionBack;
             self.draggedCell = nil;
             isGridReordering = NO;
             isCenteringCell = NO;
         }];
    }
    
}

/**
 *	@brief	Gestion du décalage des cellules
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(void)performCellShiftIfNecessary
{
    if (!isGridReordering)
    {
        // seulement si le centre est dans notre frame
        if (CGRectContainsPoint(cellContainerView.frame,self.draggedCell.center))
        {
            // on recherche l'index correspondant au centre de la cellule déplacée:
            NSInteger temporaryIndex = [self currentIndexForPoint:self.draggedCell.center];
            if (temporaryIndex < numberOfCells)
            {
                
                [UIView animateWithDuration:0.2 animations:
                 ^{
                     // si l'index est supérieur à l'index original
                     if (temporaryIndex > temporaryDraggedCellIndex)
                     {
                         NSArray *orderedKeys = [[self.visibleCells allKeys] sortedArrayUsingComparator:^(id a, id b) 
                                                 { 
                                                     return [a compare:b]; 
                                                 }]; 
                         
                         // on décale toutes les cellules visibles entre les 2 index
                         for (NSNumber *indexNumberOfCell in orderedKeys)
                         {
                             NSInteger indexForCell = [indexNumberOfCell integerValue];
                             
                             if ((indexForCell > temporaryDraggedCellIndex) && (indexForCell <=temporaryIndex))
                             {
                                 D4MGridScrollViewCell *cell = [self.visibleCells objectForKey:indexNumberOfCell];
                                 [self.visibleCells removeObjectForKey:indexNumberOfCell];
                                 [self.visibleCells setObject:cell forKey:[NSNumber numberWithInteger:indexForCell -1]];
                                 cell.center = [self centerOfCellForIndex:indexForCell -1];
                                 isGridReordering = YES;                             
                             }
                         }
                        
                         if (isGridReordering)
                         {
                             RLLogDebug(@"reordering: %d",temporaryIndex);
                             [self.visibleCells setObject:self.draggedCell forKey:[NSNumber numberWithInteger:temporaryIndex]];
                             if ((temporaryDraggedCellIndex < firstVisibleIndex) || (temporaryDraggedCellIndex > lastVisibleIndex))
                             {
                                 D4MGridScrollViewCell *cellToRemove = [self.visibleCells objectForKey:[NSNumber numberWithInteger:temporaryDraggedCellIndex]];
                                 if (cellToRemove != self.draggedCell)
                                 {
                                     [cellToRemove removeFromSuperview];
                                 }
                                 [self.visibleCells removeObjectForKey:[NSNumber numberWithInteger:temporaryDraggedCellIndex]];                                 
                             }
                             temporaryDraggedCellIndex = temporaryIndex; 
                         }  
                     }
                     // si l'index est inférieur
                     else if (temporaryDraggedCellIndex > temporaryIndex)
                     {
                         NSArray *orderedKeys = [[self.visibleCells allKeys] sortedArrayUsingComparator:^(id a, id b) 
                                                 { 
                                                     return [a compare:b ]; 
                                                 }]; 
                         // on décale toutes les cellules visibles entre les 2 index
                         for (NSNumber *indexNumberOfCell in [orderedKeys reverseObjectEnumerator])
                         {
                             NSInteger indexForCell = [indexNumberOfCell integerValue];
                             
                             if ((indexForCell >= temporaryIndex) && (indexForCell < temporaryDraggedCellIndex))
                             {
                                 D4MGridScrollViewCell *cell = [self.visibleCells objectForKey:indexNumberOfCell];
                                 [self.visibleCells removeObjectForKey:indexNumberOfCell];
                                 [self.visibleCells setObject:cell forKey:[NSNumber numberWithInteger:indexForCell +1]];
                                 cell.center = [self centerOfCellForIndex:indexForCell +1];
                                 isGridReordering = YES;
                             } 
                         }
                        
                         if (isGridReordering)
                         {
                             RLLogDebug(@"reordering: %d",temporaryIndex);
                             [self.visibleCells setObject:self.draggedCell forKey:[NSNumber numberWithInteger:temporaryIndex]];
                             if ((temporaryDraggedCellIndex < firstVisibleIndex) || (temporaryDraggedCellIndex > lastVisibleIndex))
                             {
                                 D4MGridScrollViewCell *cellToRemove = [self.visibleCells objectForKey:[NSNumber numberWithInteger:temporaryDraggedCellIndex]];
                                 if (cellToRemove != self.draggedCell)
                                 {
                                     [cellToRemove removeFromSuperview];
                                 }
                                 [self.visibleCells removeObjectForKey:[NSNumber numberWithInteger:temporaryDraggedCellIndex]];                                 
                             }
                             temporaryDraggedCellIndex = temporaryIndex; 
                         }  
                     }
                 } completion:^(BOOL finished)
                 {
                     
                     isGridReordering = NO;
                 }];    
            }
        }
    }
}


/**
 *	@brief	vibration des cellules
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
- (void)wobble 
{
    static BOOL wobblesLeft = NO;
    
    if (isEditing)
    {
        CGFloat rotation = (kWobbleRadians * M_PI) / 180.0;
        CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
        CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
        
        [UIView beginAnimations:nil context:nil];
        
        NSInteger nWobblyCells = 0;
        
        for (NSNumber *indexNumber in [self.visibleCells allKeys])
        {
            D4MGridScrollViewCell *cell = [self.visibleCells objectForKey:indexNumber];
            if (cell != draggedCell) 
            {
                [cell setEditing:YES animated:NO];
                cell.alpha = 1.0f;
                ++nWobblyCells;
                if ([indexNumber intValue] % 2) 
                {
                    cell.transform = wobblesLeft ? wobbleRight : wobbleLeft;                    
                }
                else 
                {
                    cell.transform = wobblesLeft ? wobbleLeft : wobbleRight;
                }
            }
        }
        
        if (nWobblyCells >= 1) 
        {
            [UIView setAnimationDuration:kWobbleTime];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(wobble)];
            wobblesLeft = !wobblesLeft;
            
        } 
        else 
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self performSelector:@selector(wobble) withObject:nil afterDelay:kWobbleTime];
        }
        
        [UIView commitAnimations];
    }
    else
    {
        for (UIView *cell in [self.visibleCells allValues])
        {
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0f;
        }
        [self setNeedsLayout];
    }
}

#pragma mark -Autoscroll

- (void)autoscrollTimerFired:(NSTimer*)timer
{
    // Legalisation de la distance de scroll verticale
    contentOffsetToApplyForAutoscroll.y = MIN(MAX(contentOffsetToApplyForAutoscroll.y,self.contentOffset.y*-1),cellContainerView.frame.size.height-(self.frame.size.height + self.contentOffset.y));
    
    //Legalisation de la distance de scroll horizontale
    contentOffsetToApplyForAutoscroll.x = MIN(MAX(contentOffsetToApplyForAutoscroll.x,self.contentOffset.x*-1),cellContainerView.frame.size.width-(self.frame.size.width + self.contentOffset.x));
    
    
    [self setContentOffset:CGPointMake(contentOffsetToApplyForAutoscroll.x +self.contentOffset.x,contentOffsetToApplyForAutoscroll.y+self.contentOffset.y)];
    
    CGRect newFrame = CGRectOffset(self.draggedCell.frame, contentOffsetToApplyForAutoscroll.x, contentOffsetToApplyForAutoscroll.y);
    // on deplace la cellule pour donner l'impression qu'elle ne bouge pas.
    self.draggedCell.frame = newFrame;
}

#pragma mark -Helpers

/**
 *	@brief	renvoie le centre de la cellule à l'intérieur duquel se trouve le point passé en paramêtre
 *	@param 	point 	point
 *	@return	un point representant le centre d'une cellule 
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(CGPoint)centerOfCellForPoint:(CGPoint)point
{
    NSInteger curRow = [self currentRowForPoint:point];
    NSInteger curCol =[self currentColForPoint:point];
    
    CGRect cellFrame = CGRectMake(curCol*cellSize.width, curRow*cellSize.height, cellSize.width, cellSize.height);
    
    return CGPointMake(CGRectGetMidX(cellFrame), CGRectGetMidY(cellFrame));
}

/**
 *	@brief	renvoie le centre de la cellule identifiée par son index *
 *	@param 	index 	index de la cellule *
 *	@return	un point representant le centre d'une cellule
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(CGPoint)centerOfCellForIndex:(int)index
{
    NSInteger curRow = [self rowForIndex:index];
    NSInteger curCol = [self colForIndex:index];
    
    CGRect cellFrame = CGRectMake(curCol*cellSize.width, curRow*cellSize.height, cellSize.width, cellSize.height);
    
    return CGPointMake(CGRectGetMidX(cellFrame), CGRectGetMidY(cellFrame));
}

/**
 *	@brief	renvoie la ligne correspondant à un point *
 *	@param 	point 	le point *
 *	@return	le numéro de ligne
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(NSInteger)currentRowForPoint:(CGPoint)point
{
    return MAX(0, floorf(point.y / cellSize.height));
}

/**
 *	@brief	renvoie le numéro de colonne correspondant au point de la grille *
 *	@param 	point 	un point dans le grille *
 *	@return	le numéro de colonne
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(NSInteger)currentColForPoint:(CGPoint)point
{
    return MAX(0, floorf(point.x / cellSize.width));
}

/**
 *	@brief	renvoie le numéro d'index de la cellule qui contient le point *
 *	@param 	point 	un point sur la grille *
 *	@return	l'index de la cellule
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(NSInteger)currentIndexForPoint:(CGPoint)point
{
    return ([self currentRowForPoint:point] * numberOfColumnsInGrid)+[self currentColForPoint:point];
}

-(NSInteger)indexForColumn:(NSInteger)column row:(int)row
{
    return (row*numberOfColumnsInGrid + column);
}

/**
 *	@brief	renvoie la frame d'une cellule identifiée par son index (ici les marges sont prises en compte)
 *	@param 	index 	l'index de la cellule *
 *	@return	la frame de la cellule
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(CGRect)cellFrameForIndex:(NSInteger)index
{
    CGRect frame;
    
    NSInteger curRow = [self rowForIndex:index];
    NSInteger curCol = [self colForIndex:index];
    
    frame = CGRectMake((curCol*cellSize.width)+kCellMargin,(curRow*cellSize.height)+kCellMargin, cellSize.width-(kCellMargin*2), cellSize.height-(kCellMargin*2));
    
    return frame;
}

/**
 *	@brief	renvoie le rectangle d'une cellule identifiée par son index (ici les marges ne sont pas prises en compte *
 *	@param 	index 	l'index de la cellule *
 *	@return	le rectangle correspondant
 *	@author	Gil Nakache
 *	@date	27/10/2011
 */
-(CGRect)cellPositionForIndex:(NSInteger)index
{
    CGRect frame;
    
    NSInteger curRow = [self rowForIndex:index];
    NSInteger curCol = [self colForIndex:index];
    
    frame = CGRectMake(curCol*cellSize.width,curRow*cellSize.height, cellSize.width, cellSize.height);
    
    return frame;
}

/**
 *	@brief	renvoie la ligne correspondant à l'index *
 *	@param 	index 	index*
 *	@return	un numéro de ligne
 *	@author	Gil Nakache
 *	@date	02/11/2011
 */
-(NSInteger)rowForIndex:(NSInteger)index
{
    return (index / numberOfColumnsInGrid);
}

/**
 *	@brief	renvoie la colonne correspondant à l'index *
 *	@param 	index 	index *
 *	@return	un numéro de colonne
 *	@author	Gil Nakache
 *	@date	02/11/2011
 */
-(NSInteger)colForIndex:(NSInteger)index
{
    return (index % numberOfColumnsInGrid);
}

@end
