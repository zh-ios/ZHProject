//
//  AppDelegate+Service.m
//  ZHProject
//
//  Created by zh on 2018/10/15.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "AppDelegate+Service.h"

@implementation AppDelegate (Service)

- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];

    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    self.tabbar = [ZHTabbarController new];
    self.window.rootViewController = self.tabbar;
}

@end
