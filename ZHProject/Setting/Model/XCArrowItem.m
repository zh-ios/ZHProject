//
//  XTArrowItem.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCArrowItem.h"

@implementation XCArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
                    subTitle:(NSString *)subTitle targetCls:(NSString *)cls {
    XCArrowItem *item = [[XCArrowItem alloc] init];
    item.targetClass = cls;
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title targetCls:(NSString *)cls {
    return [self itemWithIcon:icon title:title subTitle:nil targetCls:cls];
}

@end
