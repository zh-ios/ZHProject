//
//  XCTextField.m
//  XCTextFieldTest
//
//  Created by zh on 2018/7/6.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "XCTextField.h"

@implementation XCTextField



- (void)drawPlaceholderInRect:(CGRect)rect {
    UIColor *placeHolderColor = self.placeHolderColor ?: [UIColor lightGrayColor];
    UIFont * font = self.placeHolderFont ?: [UIFont systemFontOfSize:14];
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : placeHolderColor}];
}



-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGFloat x = 0;
    if (self.leftView&&(self.leftViewMode == UITextFieldViewModeAlways||
                        self.leftViewMode == UITextFieldViewModeUnlessEditing)
        ) {
        x = self.leftView.frame.origin.x + self.leftView.frame.size.width;
    }
    if (self.leftView&&self.leftViewMode == UITextFieldViewModeWhileEditing&&self.isEditing) {
        x = self.leftView.frame.origin.x + self.leftView.frame.size.width;
    }
    CGRect inset = CGRectMake(x, (self.bounds.size.height - self.font.pointSize) * 0.5,
                              bounds.size.width, bounds.size.height);
    return inset;
}

@end
