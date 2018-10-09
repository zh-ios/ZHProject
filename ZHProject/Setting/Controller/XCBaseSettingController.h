//
//  XCBaseSettingController.h
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCArrowItem.h"
#import "XCSwitchItem.h"
#import "XCLabelItem.h"
#import "XCCellGroupItem.h"
#import "ZHBaseController.h"
@interface XCBaseSettingController : ZHBaseController

// XCCellGroupItem 对象集合
@property (nonatomic, strong) NSArray<XCCellGroupItem *> *groupItems;

@property (nonatomic, strong) UIView *tableHeaderView;

@property (nonatomic, strong) UIView *tableFooterView;

- (void)reloadData;
    
@end
