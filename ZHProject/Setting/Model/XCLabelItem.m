//
//  XTLabelItem.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCLabelItem.h"

@implementation XCLabelItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle accessoryDesc:(NSString *)desc {
    XCLabelItem *item = [[XCLabelItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    item.accessoryDesc = desc;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title desc:(NSString *)desc {
    return [self itemWithIcon:icon title:title subTitle:nil accessoryDesc:desc];
}

@end
