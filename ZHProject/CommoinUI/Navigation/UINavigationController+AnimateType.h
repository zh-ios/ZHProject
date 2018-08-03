//
//  UINavigationController+AnimateType.h
//  ZHProject
//
//  Created by zh on 2018/7/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NaviAnimationType) {
    NaviAnimationType_Right2Left = 0,
    NaviAnimationType_Bottom2Top,
    NaviAnimationType_None
};

@interface UINavigationController (AnimateType)


- (void)pushViewController:(UIViewController *)viewController
             animationType:(NaviAnimationType)type
            fromController:(UIViewController *)fromVC
              toController:(UIViewController *)toVC;


@end
