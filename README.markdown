AUIScrollViewLayout
================

This is a demo project (for iPhone, and iPad) makes tiling the content view of a scrollview simpler and managing resolution easier.
This is very useful for having controller class code cleaner and less spaghetti.
It is very loosely based on the WWDC10-SampleCode's ScrollViewSuite demo you can find at http://developer.apple.com/devcenter/ios/

AUIScrollView
------------------------

This UIScrollView takes the role of layout it's subview that is typically done by the controller.

- layouts all its subviews in the center if their contentMode is UIViewContentModeCenter.
- send a setNeedsDisplay to its subviews.

This is very useful making the controller class code cleaner and less spaghetti.

AUIGridView
------------------------

This UIView subclass create and lays out tiles with the same size in efficient and simple way.

This is very useful making the controller class code cleaner and less spaghetti.

RootViewController
------------------------

This UIViewController subclass is a UIScrollViewDelegate that takes coordinate the UIScrollView with the it's content.

- tell the content to scale its tiles when the zoomScale changes in more than 0.25

This is very useful making the controller class code cleaner and less spaghetti.

License
------------------------

The license for the code is included with this project; it's basically a BSD license with attribution and it's based on Matt Legend Gemmell / Instinctive Code Source Code License from the 9th May 2010
In the hope you'd find it useful,I'd love if you write me you about your experience of this and would love seeing forks of it on github.com. 
I will not answer questions about it though.


thanks again! 
Amos Elmaliah
http://amosel.org/  
