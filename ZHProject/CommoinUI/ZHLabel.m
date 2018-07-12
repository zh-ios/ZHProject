//
//  ZHLabel.m
//  ZHProject
//
//  Created by zh on 2018/7/11.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHLabel.h"

@implementation ZHLabel

- (instancetype)Color:(UIColor *)textColor {
    self.textColor = textColor;
    return self;
}

- (instancetype)textfont:(UIFont *)font {
    self.font = font;
    return self;
}

@end
