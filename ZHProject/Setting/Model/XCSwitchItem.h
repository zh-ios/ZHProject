//
//  XTSwitchItem.h
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//  右侧是开关的cell模型

#import "XCCellItem.h"
NS_ASSUME_NONNULL_BEGIN
@interface XCSwitchItem : XCCellItem


/**
 开关的状态
 */
@property (nonatomic, assign) BOOL switchOn;
// 开关是否可以点击
@property (nonatomic, assign) BOOL switchEnabled;

/**
 @param icon cell的图片，没有传nil或者@“”
 @param title cell的标题
 @return cell对应的模型对象
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title;


/**
 @param icon cell的图片，没有传nil或者@“”
 @param title cell的标题
 @param subTitle cell子标题，详细描述
 @return cell对应的模型
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle;

@end
NS_ASSUME_NONNULL_END
