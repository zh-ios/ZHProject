//
//  XTSwitchItem.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCSwitchItem.h"

@implementation XCSwitchItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle {
    XCSwitchItem *item = [[XCSwitchItem alloc] init];
    item.icon = icon;
    item.title = title;
    item.subTitle = subTitle;
    item.switchEnabled = YES;
    return item;
}

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title {
    return [self itemWithIcon:icon title:title subTitle:nil];
}

@end
