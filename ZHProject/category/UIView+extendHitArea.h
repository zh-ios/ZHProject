//
//  UIView+enlargeHitArea.h
//  ZHProject
//
//  Created by autohome on 2018/3/7.
//  Copyright © 2018年 autohome. All rights reserved.
//  扩大view的响应点击区域

#import <UIKit/UIKit.h>

@interface UIView (extendHitArea)

/*!
 @property
 @abstract 要扩展的区域
 @如上下左右扩展20的可点击区域 extendedHitArea = {20,20,20,20};
 */
@property(nonatomic, assign) CGRect extendedHitArea;
// or 
- (void)extendHitAreaTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;


@end
