//
//  ZHNavigationController.m
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHNavigationController.h"
#import "ZHBaseController.h"
@interface ZHNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation ZHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 这么设置状态栏的颜色会自动根据底色变化，而且支持返回手势
    self.navigationBarHidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.customNavgationBar];
    self.customNavgationBar.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
//    if (self.viewControllers.count>1) { // not worked
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
}



@end
