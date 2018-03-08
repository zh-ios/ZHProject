//
//  UIView+coordinate.m
//  ZHProject
//
//  Created by autohome on 2018/3/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "UIView+coordinate.h"

@implementation UIView (coordinate)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGFloat)top
{
    return self.y;
}

- (void)setTop:(CGFloat)top
{
    [self setY:top];
}

- (CGFloat)left
{
    return self.x;
}

- (void)setLeft:(CGFloat)left
{
    [self setX:left];
}

- (CGFloat)bottom
{
    return self.y - self.height;
}

- (void)setBottom:(CGFloat)bottom
{
    [self setY:bottom - self.height];
}

- (CGFloat)right
{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right
{
    self.x = right - self.width;
}


@end
