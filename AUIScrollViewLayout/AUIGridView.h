//
//  AUIGridView.h
//  AUIScrollViewLayout
//
//  Created by Amos Elmaliah on 8/7/11.
//  Copyright 2011 UIMUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AUIGridView : UIView
{
@private
    NSMutableIndexSet* tilesIndicesToShow;
}

@property(nonatomic)CGSize tileSize;
@property(nonatomic) CGFloat zoomScale;
@end
