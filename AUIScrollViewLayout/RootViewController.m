//
//  RooViewController.m
//  AUIScrollViewLayout
//
//  Created by Amos Elmaliah on 8/8/11.
//  Copyright 2011 UIMUI. All rights reserved.
//

#import "RootViewController.h"
#import "AUIGridView.h"
#import "AUIScrollView.h"

@implementation RootViewController

{
    AUIGridView* gridContainerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    AUIScrollView* scrollView = [[AUIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setDelegate:self];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [scrollView setBouncesZoom:YES];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    CGRect frame = [scrollView bounds];
    frame.size.height = frame.size.width;
    frame.size.height *= 4;
    frame.size.width *= 4;
    
    gridContainerView = [[AUIGridView alloc] initWithFrame:frame];
    [gridContainerView setContentMode:UIViewContentModeCenter];
    [gridContainerView setClipsToBounds:YES];
    
    // choose minimum scale so image width fills screen
    float minScale = scrollView.bounds.size.width  / gridContainerView.frame.size.width;
    [scrollView setMinimumZoomScale:minScale];
    [scrollView setZoomScale:minScale];    
    [scrollView addSubview:gridContainerView];
    
    [[self view] addSubview:scrollView];
}


#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return gridContainerView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    static CGFloat lastZoomScale = CGFLOAT_MAX;
    CGFloat zoomScale = [scrollView zoomScale];
    
    BOOL change = fabsf(zoomScale-lastZoomScale) > 0.25 || CGFLOAT_MAX == lastZoomScale;
    if (change) 
    {
        [gridContainerView setZoomScale:[scrollView zoomScale]];
        lastZoomScale = zoomScale;
    }
}

@end
