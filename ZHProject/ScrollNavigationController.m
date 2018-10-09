//
//  ScrollNavigationController.m
//  ZHProject
//
//  Created by zh on 2018/9/7.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ScrollNavigationController.h"
#import "ZZScrollNavigationBar.h"
#import "ZHReuseableController.h"
@interface ScrollNavigationController ()<ZZScrollNavigationBarDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) ZZScrollNavigationBar *bar;
@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) NSMutableArray *visiableControllers;
@property (nonatomic, strong) NSMutableArray *reuseableControllers;
@property (nonatomic, strong) NSNumber *currentIndex;
@end

@implementation ScrollNavigationController

- (NSMutableArray *)visiableControllers {
    if (!_visiableControllers) {
        _visiableControllers = @[].mutableCopy;
    }
    return _visiableControllers;
}
- (NSMutableArray *)reuseableControllers {
    if (!_reuseableControllers) {
        _reuseableControllers = @[].mutableCopy;
    }
    return _reuseableControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.customNavView.backgroundColor = [UIColor whiteColor];
    
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
    
    [self loadPage:0];

}

- (void)loadPage:(NSInteger)index {
    if (self.currentIndex && [self.currentIndex integerValue] == index) return;
    self.currentIndex = @(index);
    NSMutableArray *pagesToload = @[@(index-1),@(index),@(index+1)].mutableCopy;
    NSMutableArray *controllersToEnqueue =@[].mutableCopy;
    for (int i = 0; i<self.visiableControllers.count; i++) {
        ZHReuseableController *controller = self.visiableControllers[i];
        // 如果不再展示则放入队列
        if (!controller.page || ![pagesToload containsObject:controller.page]) {
            [controllersToEnqueue addObject:controller];
            // 如果正在展示则从队列中移除
        } else if (controller.page) {
            [pagesToload removeObject:controller.page];
        }
    }
    for (ZHReuseableController *controller in controllersToEnqueue) {
        [controller.view removeFromSuperview];
        [self.visiableControllers removeObject:controller];
        // 入重用队列
        [self enqueueViewController:controller];
    }
    for (NSNumber *index in pagesToload) {
        [self addViewControllerForIndex:[index integerValue]];
    }
}

- (void)enqueueViewController:(ZHReuseableController *)controller {
    [self.reuseableControllers addObject:controller];
}
- (ZHReuseableController *)dequeueViewController {
    static int numberOfInstance = 0;
    ZHReuseableController *vc = [self.reuseableControllers firstObject];
    if (vc) {
        [self.reuseableControllers removeObject:vc];
    } else {
        vc = [[ZHReuseableController alloc] init];
        vc.instanceName = [NSString stringWithFormat:@"instancel--.%@",@(numberOfInstance)];
        numberOfInstance++;
//        [self willMoveToParentViewController:vc];
//        [self addChildViewController:vc];
//        [self didMoveToParentViewController:vc];
    }
    return vc;
}
- (void)addViewControllerForIndex:(NSInteger)index {
    if (index < 0 || index >= self.bar.titles.count) {
        return;
    }
    ZHReuseableController *vc = [self dequeueViewController];
    vc.page = @(index);
    vc.view.frame = CGRectMake(self.container.frame.size.width * index, 0.0, self.container.frame.size.width, self.container.frame.size.height);
    [self.container addSubview:vc.view];
    [self addChildViewController:vc];
    [self.visiableControllers addObject:vc];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.bar targetScollViewDidScroll:scrollView];
    
    NSInteger page = roundf(scrollView.contentOffset.x / scrollView.frame.size.width);
    page = MAX(page, 0);
    page = MIN(page, self.bar.titles.count - 1);
    [self loadPage:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.bar targetScrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewNavigationBar:(ZZScrollNavigationBar *)bar selectedIndex:(NSInteger)index {
    [self.container setContentOffset:CGPointMake(self.view.width*index, 0) animated:NO];
}


@end
