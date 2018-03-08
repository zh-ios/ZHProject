//
//  UIView+enlargeHitArea.m
//  ZHProject
//
//  Created by autohome on 2018/3/7.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "UIView+extendHitArea.h"
#import <objc/runtime.h>
@implementation UIView (extendHitArea)

//static char *nameKeyKey;
//static const void *nameKey = &nameKey;
//@selector(extendedHitArea)
static char *kLeft_extendKey;
static char *kRight_extendKey;
static char *kBottom_extendKey;
static char *kTop_extendKey;

- (void)extendHitArea:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, kLeft_extendKey, @(left), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kBottom_extendKey, @(bottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kRight_extendKey, @(right), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kTop_extendKey, @(top), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*!
 @method 可以响应点击事件的rect
 */
- (CGRect)responseHitArea {
    
    NSNumber *left = objc_getAssociatedObject(self, kLeft_extendKey);
    NSNumber *top = objc_getAssociatedObject(self, kTop_extendKey);
    NSNumber *right = objc_getAssociatedObject(self, kRight_extendKey);
    NSNumber *bottom = objc_getAssociatedObject(self, kBottom_extendKey);
    if (left&&top&&right&&bottom) {
        return CGRectMake(
                          self.bounds.origin.x-left.floatValue,
                          self.bounds.origin.y-top.floatValue,
                          self.bounds.size.width+left.floatValue+right.floatValue,
                          self.bounds.size.height+top.floatValue+bottom.floatValue);
    } else {
        return self.frame;
    }
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect responseArea = [self responseHitArea];
    return CGRectContainsPoint(responseArea, point);
}

@end
