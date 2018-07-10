//
//  XTCellItem.h
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCCellItem;

typedef void (^CellOnClickBlock)(XCCellItem *item);

@interface XCCellItem : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
// 二级详细描 => 标题  子标题  >
@property (nonatomic, copy) NSString *subTitle;

/**
  cell点击事件的回调,对于箭头类型cell，如果没有实现block则会自动跳转到对应targetVC，否则自己处理跳转逻辑。
  对于其他类型，则是点击对应 accessoryView 的回调，如：switch， 清理缓存label等。
 */
@property (nonatomic, copy, nonnull) CellOnClickBlock onClicked;

@end
