//
//  AUIGridView.m
//  AUIScrollViewLayout
//
//  Created by Amos Elmaliah on 8/7/11.
//  Copyright 2011 UIMUI. All rights reserved.
//

#import "AUIGridView.h"
#import <QuartzCore/QuartzCore.h>

@interface AUIGridView ()
- (void)annotateTile:(UIView *)tile;
@end

@implementation AUIGridView
{
    NSMutableArray* viewsToRecycle;
}
@synthesize tileSize;
@synthesize zoomScale;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor blackColor];
        self.tileSize = CGSizeMake(128, 128);
        self.zoomScale = 1.;
        [[self layer] setBorderWidth:2];
        [[self layer] setBorderColor:[[UIColor blueColor] CGColor]];
        
        viewsToRecycle = [NSMutableArray array];
        
        // Initialization code
    }
    return self;
}

#define LABEL_TAG 20

- (void)annotateTile:(UIView *)tile
{
    //return;
    UILabel *label = (UILabel *)[tile viewWithTag:LABEL_TAG];
    if (!label) {  
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTag:LABEL_TAG];
        [label setTextColor:[UIColor greenColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label setFont:[UIFont boldSystemFontOfSize:40]];
        [tile addSubview:label];
    }
    
    [tile bringSubviewToFront:label];
    [[tile layer] setBorderWidth:2];
    [[tile layer] setBorderColor:[[UIColor greenColor] CGColor]];
    
    [label setText:[NSString stringWithFormat:@"%d", [self.subviews indexOfObject:tile]]];
    
}

- (void)annotateTile2:(UIView *)tile 
{    
    UILabel *label = (UILabel *)[tile viewWithTag:LABEL_TAG];
    if (label) {  
        [[tile layer] setBorderColor:[[UIColor redColor] CGColor]];
    }
}

- (CGRect)visibleBounds
{
    CGRect selfInWindowCoordinates = [self.window convertRect:self.bounds fromView:self];
    CGRect visibleViewInWindowCoordinates = CGRectIntersection(selfInWindowCoordinates, self.window.bounds);
    CGRect visibleViewInOwnCoordinates = [self.window convertRect:visibleViewInWindowCoordinates toView:self];
	return visibleViewInOwnCoordinates;
}

-(CGRect)visibleBoundsForView:(UIView*)view
{
    CGRect result = CGRectZero;
    if ([self.subviews indexOfObjectIdenticalTo:view] != NSNotFound)
    {
        result = CGRectIntersection(view.frame, [self visibleBounds]);
    }
    return result;
}

#define tagOffset 123

NSMutableIndexSet* NSMutableIndexSetMake(int columnOffset, int columns, int rowsLength, int columnsLenght);
NSMutableIndexSet* NSMUtableIndexSetFromCGRect(CGRect rect);

NSMutableIndexSet* NSMutableIndexSetMake(int columnOffset, int rowOffset, int columnsLength, int rowsLength)
{
    int row;
    NSMutableIndexSet*set = [[NSMutableIndexSet alloc] init];
    
    for (row = rowOffset; row<(rowsLength+rowOffset); row++)
    {
        NSRange range = NSMakeRange(columnOffset+(row *(columnsLength+columnOffset)), columnsLength);
        [set addIndexesInRange:range];
    }
    return set;
}

NSMutableIndexSet* NSMUtableIndexSetFromCGRect(CGRect rect)
{
    return NSMutableIndexSetMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

-(CGSize)scaledTileSize
{
    CGSize scaledTileSize = self.tileSize;
    scaledTileSize.width /= [self zoomScale];
    scaledTileSize.height/= [self zoomScale];
    
    return scaledTileSize;
}

- (void)layoutSubviews 
{
    
    NSUInteger index= 0;
    UIView*tile;
    int row, col;
    
    //suffling view based on indices: add if not exists,     
    CGRect visibleBounds = [self visibleBounds];
    CGSize scaledTileSize = [self scaledTileSize];
    float scaledTileWidth  = scaledTileSize.width;
    float scaledTileHeight = scaledTileSize.height;
    int maxRowIndex = floorf((self.bounds.size.height-1)  / scaledTileHeight); // this is the maximum possible row
    int maxColIndex = floorf((self.bounds.size.width-1)  / scaledTileWidth);  // and the maximum possible column
    int firstVisibleRowIndex = MAX(0, floorf(visibleBounds.origin.y / scaledTileHeight)); // self.bound reflects changes in transform...
    int firstVisibleColIndex = MAX(0, floorf(visibleBounds.origin.x / scaledTileWidth));
    int lastVisibleRowIndex  = MIN(maxRowIndex, floorf(CGRectGetMaxY(visibleBounds) / scaledTileHeight));
    int lastVisibleColIndex  = MIN(maxColIndex, floorf(CGRectGetMaxX(visibleBounds) / scaledTileWidth));
    
    NSMutableIndexSet* indicesToShow = NSMutableIndexSetMake(firstVisibleColIndex, 
                                                             firstVisibleRowIndex, 
                                                             (lastVisibleColIndex+1)-firstVisibleColIndex,
                                                             (lastVisibleRowIndex+1)-firstVisibleRowIndex);
    
    
    // first put into the recycled bin if needed:
    NSUInteger numberOfTilesToRecycle = [self.subviews count] > [indicesToShow count] ? [self.subviews count] - [indicesToShow count] : 0;
    for (index=0; index< numberOfTilesToRecycle; index++)
    {
        tile = [self.subviews lastObject];
        [viewsToRecycle addObject:tile];
        [tile removeFromSuperview];
    }
    
    // if tiles are needed 
    NSUInteger numberOfTileToMissing = [indicesToShow count] > [self.subviews count] ? [indicesToShow count] - [self.subviews count] : 0;
    for (index = 0; index < numberOfTileToMissing; index++) 
    {
        tile = [viewsToRecycle lastObject];
        if (!tile)
        {
            tile = [[UIView alloc] initWithFrame:CGRectZero];
            tile.backgroundColor = [UIColor redColor];
        }
        else
        {
            [viewsToRecycle removeObject:tile];
            [tile setHidden:NO];
        }
        
        [self addSubview:tile];
    }
    
    // if there are too many tiles:    
    NSAssert([self.subviews count] == [indicesToShow count], @"there are %d subviews, there should be %d", [self.subviews count], [indicesToShow count]);
    
    // layout:
    CGRect frame = CGRectMake(0, 0,scaledTileWidth, scaledTileHeight);
    
    index = [indicesToShow firstIndex];
    for (tile in self.subviews)
    {
        col = (index)%(lastVisibleColIndex+1);
        row = (index)/(lastVisibleColIndex+1);
        frame.origin = CGPointMake(col*scaledTileWidth, 
                                   row*scaledTileHeight);
        
        [tile setFrame:frame];
        [self annotateTile:tile];
        index = [indicesToShow indexGreaterThanIndex:index];
    }
}

-(void)removeUnnecessaryViews
{
    // for all the view that are on the view and were not recycled, here we move them away to the reusable View collection;
    // this can actually optimize based on weighing what's more expensize to do many view add/revmoe or having more views on the view tree that aren't really on, on top of this - if we have many instances of this view(TiledScrollView, it might make sense to use the main controller to recicle the the TileViews.
    // at any rate this most likely should be done at greater intervals, 
    // something like at UIScrollViewDelegate scrollViewDidEndZooming: withView:atScale:
    
    for (UIView* tile in viewsToRecycle)
    {
        if ([tile subviews])
            [tile removeFromSuperview];
    }
}


@end
