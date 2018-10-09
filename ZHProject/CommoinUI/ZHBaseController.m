//
//  ZHBaseController.m
//  ZHProject
//
//  Created by zh on 2018/9/27.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHBaseController.h"
#import "ZHNavigationAnimation.h"
#import "ZHNavigationController.h"
@interface ZHBaseController ()<UINavigationControllerDelegate>

@end

@implementation ZHBaseController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    ZHNavigationController *nav = (ZHNavigationController *)self.navigationController;
    self.customNavView = nav.customNavgationBar;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        ZHNavigationAnimation *animation = [[ZHNavigationAnimation alloc] init];
        animation.isPush = NO;
        return animation;
    }
    if (operation == UINavigationControllerOperationPush) {
        ZHNavigationAnimation *animation = [[ZHNavigationAnimation alloc] init];
        animation.isPush = YES;
        ZHBaseController *fromViewController = (ZHBaseController *)fromVC;
        ZHBaseController *toViewController = (ZHBaseController *)toVC;
        fromViewController.animationType = toViewController.animationType;
        animation.animationType = toViewController.animationType;
        return animation;
    }
    if (operation == UINavigationControllerOperationNone) {
        return nil;
    }
    return nil;
}



@end
