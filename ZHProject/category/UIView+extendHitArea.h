//
//  UIView+enlargeHitArea.h
//  ZHProject
//
//  Created by autohome on 2018/3/7.
//  Copyright © 2018年 autohome. All rights reserved.
//  扩大view的响应点击区域

#import <UIKit/UIKit.h>

@interface UIView (extendHitArea)

- (void)extendHitArea:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
