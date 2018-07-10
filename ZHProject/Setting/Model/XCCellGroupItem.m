//
//  XTCellGroupItem.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCCellGroupItem.h"

@implementation XCCellGroupItem
    
    
+ (instancetype)itemWithItems:(NSArray<XCCellItem *> *)items {
    XCCellGroupItem *item = [[XCCellGroupItem alloc] init];
    item.items = items;
    return item;
}

@end
