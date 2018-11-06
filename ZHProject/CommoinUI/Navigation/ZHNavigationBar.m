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
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, kTopSafeArea+10, 80, 30)];
    backBtn.backgroundColor = [UIColor orangeColor];
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, self.frame.size.height-20, self.frame.size.width-100*2, 20)];
    titleL.font = [UIFont systemFontOfSize:20];
    self.titleL = titleL;
    [self addSubview:titleL];
}

- (void)back {
    if (self.backOnClick) {
        self.backOnClick();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleL sizeToFit];
    self.titleL.centerX = self.centerX;
    
    self.titleL.y = kTopSafeArea + 20;
}

@end
