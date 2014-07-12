//
//  UIView+Test.m
//  furgonapp
//
//  Created by Wojciech Chojnacki on 26.11.2013.
//  Copyright (c) 2013 Orta Systems. All rights reserved.
//

#import "UIView+TableViewCell.h"

@implementation UIView (TableViewCell)
- (UIView *)findSuperViewWithClass:(Class)superViewClass {
    
    UIView *superView = self.superview;
    
    while (nil != superView) {
        if ([superView isKindOfClass:superViewClass]) {
            return superView;
        } else {
            superView = superView.superview;
        }
    }
    return nil;
}
@end
