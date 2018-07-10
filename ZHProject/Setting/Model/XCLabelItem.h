//
//  XTLabelItem.h
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//  右侧是文字的cell模型

#import "XCCellItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCLabelItem : XCCellItem


/**
  右侧label 的标题
 */
@property (nonatomic, copy, nonnull) NSString *accessoryDesc;


/**
  文字的颜色
 */
@property (nonatomic, strong, nullable) UIColor *textColor;


/**
 @param desc label的标题
 */
+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                    subTitle:(nullable NSString *)subTitle
               accessoryDesc:(NSString *)desc;

+ (instancetype)itemWithIcon:(nullable NSString *)icon
                       title:(NSString *)title
                        desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
