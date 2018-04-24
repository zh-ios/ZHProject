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

//static const void *nameKey = &nameKey;
static char *kLeft_extendKey;
static char *kRight_extendKey;
static char *kBottom_extendKey;
static char *kTop_extendKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalM = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
        Method swzM = class_getInstanceMethod([self class], @selector(swz_pointInside:withEvent:));
        BOOL addMethod = class_addMethod([self class], @selector(pointInside:withEvent:), method_getImplementation(swzM), method_getTypeEncoding(swzM));
        if (addMethod) {
            class_replaceMethod([self class], @selector(swz_pointInside:withEvent:), method_getImplementation(originalM), method_getTypeEncoding(originalM));
        } else {
            method_exchangeImplementations(originalM, swzM);
        }
    });
}

- (void)setExtendedHitArea:(CGRect)extendedHitArea {
    objc_setAssociatedObject(self, @selector(extendedHitArea), @(extendedHitArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)extendedHitArea {
    CGRect rect = [objc_getAssociatedObject(self, @selector(extendedHitArea)) CGRectValue];
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return self.bounds;
    }
    return rect;
}

/*!
 @method 可以响应点击事件的rect
 */
- (CGRect)responseHitArea {
    CGRect extendedHitArea = [objc_getAssociatedObject(self, @selector(extendedHitArea)) CGRectValue];
    if (!CGRectEqualToRect(extendedHitArea, CGRectZero)) {
        return                       CGRectMake(
                                     self.bounds.origin.x-extendedHitArea.origin.x,
                                     self.bounds.origin.y-extendedHitArea.origin.y,
                                     self.bounds.size.width+extendedHitArea.origin.x+extendedHitArea.size.width,
                                     self.bounds.size.height+extendedHitArea.origin.y+extendedHitArea.size.height);
        
    } else {
        return self.bounds;
    }
}

- (BOOL)swz_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [self swz_pointInside:point withEvent:event];
    CGRect responseHitArea = [self responseHitArea];
    BOOL ret = ( result
                ||CGRectEqualToRect(responseHitArea, CGRectZero)
                ||!self.isUserInteractionEnabled
                ||self.isHidden);
    if (ret) return result;
    return CGRectContainsPoint(responseHitArea, point);
}

/////////////////////////////////////////////////////////////////////////
- (CGRect)resonseHitArea_associateObj {
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
            return self.bounds;
        }
}

- (void)extendHitAreaTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, kLeft_extendKey, @(left), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kBottom_extendKey, @(bottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kRight_extendKey, @(right), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kTop_extendKey, @(top), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden||!self.isUserInteractionEnabled) {
        return NO;
    }
    CGRect responseArea = [self resonseHitArea_associateObj];
    return CGRectContainsPoint(responseArea, point);
}

@end
