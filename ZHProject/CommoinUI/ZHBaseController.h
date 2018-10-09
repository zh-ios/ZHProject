//
//  ZHBaseController.h
//  ZHProject
//
//  Created by zh on 2018/9/27.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHNavigationDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHBaseController : UIViewController


/**
 从当前控制器 push 出去的anitionType, 如从AVC push 到 BVC,需要设置 BVC.animationType = ...
 */
@property (nonatomic, assign) NaviAnimationType animationType;

@property (nonatomic, strong) UIView *customNavView;

@end

NS_ASSUME_NONNULL_END
