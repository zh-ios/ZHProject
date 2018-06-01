//
//  ZHRetViewStacksTool.h
//  CommonFunction
//
//  Created by zh on 2018/6/1.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHResettViewStacksTool : NSObject

/**
 重置导航控制的堆栈
 
 @param vc 要重置的控制器,在控制器页面传 self
 @param vcNames 要去掉的控制器的名字集合
 */
+ (void)resetViewStacksOfViewController:(UIViewController *)vc
                                popedVC:(NSArray<NSString *> *)vcNames;

@end
