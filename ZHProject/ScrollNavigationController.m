//
//  ScrollNavigationController.m
//  ZHProject
//
//  Created by zh on 2018/9/7.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ScrollNavigationController.h"
#import "ZZScrollNavigationBar.h"
@interface ScrollNavigationController ()<ZZScrollNavigationBarDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) ZZScrollNavigationBar *bar;
@property (nonatomic, strong) UIScrollView *container;
@end

@implementation ScrollNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ZZScrollNavigationBar *bar = [[ZZScrollNavigationBar alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width-40, 43)];
    self.bar = bar;
    bar.titles = @[@"推荐",@"头条",@"新闻",@"资讯类节目",@"小游戏测试",@"单机",@"多人对战",@"约战"];
    [self.view addSubview:bar];
    bar.delegate = self;
    
    UIScrollView *container = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavbarHeight+43, self.view.width, self.view.height-kNavbarHeight-kBottomSafeArea)];
    [self.view addSubview:container];
    container.contentSize = CGSizeMake(self.view.width*bar.titles.count,0);
    container.pagingEnabled = YES;
    container.delegate = self;
    self.container = container;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.bar targetScollViewDidScroll:scrollView];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.bar targetScrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewNavigationBar:(ZZScrollNavigationBar *)bar selectedIndex:(NSInteger)index {
    [self.container setContentOffset:CGPointMake(self.view.width*index, 0) animated:NO];
}


@end
