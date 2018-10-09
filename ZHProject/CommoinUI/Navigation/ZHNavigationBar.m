//
//  ZHNavigationBar.m
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHNavigationBar.h"

@implementation ZHNavigationBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(20, kTopSafeArea+10, 80, 30)];
    b.backgroundColor = [UIColor orangeColor];
    [self addSubview:b];
    [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    if (self.backOnClick) {
        self.backOnClick();
    }
}

@end
