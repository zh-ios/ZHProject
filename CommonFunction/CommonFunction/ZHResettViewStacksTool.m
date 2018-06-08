//
//  ZHRetViewStacksTool.m
//  CommonFunction
//
//  Created by zh on 2018/6/1.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "ZHResettViewStacksTool.h"

@implementation ZHResettViewStacksTool

+ (void)resetViewStacksOfViewController:(UIViewController *)vc
                                popedVC:(NSArray<NSString *> *)vcNames {
    if (![[NSThread currentThread] isMainThread]) assert("请在主线程中进行...");
    
    if (vc.navigationController.viewControllers.count < 2) return;
    if (vcNames.count == 0) return;
    NSMutableArray *vcCls = @[].mutableCopy;
    for (NSString *clsName in vcNames) {
        [vcCls addObject:NSClassFromString(clsName)];
    }
    
    NSMutableArray *maintainedCls = @[].mutableCopy;
    for (UIViewController *childVC in vc.navigationController.viewControllers) {
        if (![vcCls containsObject:[childVC class]]) {
            [maintainedCls addObject:childVC];
        }
    }
    vc.navigationController.viewControllers = [maintainedCls copy];
}

@end
