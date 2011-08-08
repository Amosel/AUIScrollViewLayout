//
//  AUIScrollView.m
//  AUIScrollViewLayout
//
//  Created by Amos Elmaliah on 8/7/11.
//  Copyright 2011 UIMUI. All rights reserved.
//

#import "AUIScrollView.h"

@implementation AUIScrollView

-(void)layoutSubviews
{
    for (UIView*view in self.subviews) 
    {
        switch ([view contentMode])
        {
            case UIViewContentModeCenter:
            {
                CGSize boundsSize = self.bounds.size;
                CGRect frameToCneter = view.frame;
                
                // center verticaly:
                if (frameToCneter.size.width < boundsSize.width)
                    frameToCneter.origin.x = (boundsSize.width - frameToCneter.size.width)/2;
                else
                    frameToCneter.origin.x = 0;
                // center horizontaly
                if (frameToCneter.size.height < boundsSize.height)
                    frameToCneter.origin.y = (boundsSize.height - frameToCneter.size.height)/2;
                else
                    frameToCneter.origin.y = 0;
                
                view.frame = frameToCneter;
            }
                break;
            default:
                break;
        }
    }
    if (self.autoresizesSubviews)
    {
        for (UIView*view in self.subviews)
        {
            [view setNeedsLayout];
        }
    }
}

@end
