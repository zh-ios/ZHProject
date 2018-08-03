//
//  ZHNavigationController.m
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHNavigationController.h"

@interface ZHNavigationController ()


@end

@implementation ZHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    
    self.customNavgationBar = [[ZHNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kNavbarHeight)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.customNavgationBar];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
//    if (self.viewControllers.count>1) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
}



@end
