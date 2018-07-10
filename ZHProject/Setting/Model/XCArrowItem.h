//
//  XTArrowItem.h
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//  右侧带有箭头的cell，这种一般都是跳转页面

#import "XCCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCArrowItem : XCCellItem


/**
  要跳转的类名字
 */
@property (nonatomic, copy, nullable) NSString *targetClass;

/**
  是否显示 （new） 提示 ，new 提示和subtitle UI上存在冲突，没有处理。
 */
@property (nonatomic, assign) BOOL showNewTips;


/**
 @param cls 要跳转目标控制器名字
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle
                    targetCls:(nullable NSString *)cls;


+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    targetCls:(nullable NSString *)cls;
@end

NS_ASSUME_NONNULL_END
