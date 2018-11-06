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
#import "ZHNavigationBar.h"
@interface ZHBaseController ()<UINavigationControllerDelegate>


@end

@implementation ZHBaseController

- (void)setTitle:(NSString *)title {
    self.customNavView.titleL.text = title?:@"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
//    self.customNavView.titleL.text = self.title?:@"";
//    [self.customNavView.backBtn setTitle:self.title?:@"" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = self.panGestureEnabled;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 页面消失的时候，重置返回手势为可用
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// 将 customnaviView 添加到每个页面控制器上，滑动返回的时候，navivie 也会跟着返回
// 如果要想微信 导航条不动，渐变的那种需要使用原生导航
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.panGestureEnabled = YES;
    
    
    __weak typeof(self)weakSelf = self;
    ZHNavigationBar *navibar = [[ZHNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavbarHeight)];
    [self.view addSubview:navibar];
    self.customNavView = navibar;
    navibar.backOnClick = ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf back];
    };
    if (self.navigationController) {
        if (self.navigationController.childViewControllers.count>=2) {
            self.customNavView.backBtn.hidden = NO;

            ZHBaseController *lastVc = self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-2];
            [self.customNavView.backBtn setTitle:lastVc.customNavView.titleL.text?:@"" forState:UIControlStateNormal];
        } else {
            self.customNavView.backBtn.hidden = YES;
        }
    }
}

-(UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}

- (void)back {
    if (!self.presentedViewController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
