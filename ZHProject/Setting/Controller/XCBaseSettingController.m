//
//  XCBaseSettingController.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCBaseSettingController.h"
#import "XCCommonSettingCell.h"

@interface XCBaseSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XCBaseSettingController

static NSString *const cellId = @"xccommonsetttingcellid";

- (UITableView *)tableView {
    if (!_tableView) {
        // TODO ... 高度
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 44;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
    }
}

- (void)setTableFooterView:(UIView *)tableFooterView {
    _tableFooterView = tableFooterView;
    self.tableView.tableFooterView = tableFooterView;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
    _tableHeaderView = tableHeaderView;
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XCCellGroupItem *group = self.groupItems[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XCCommonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[XCCommonSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    XCCellGroupItem *group = self.groupItems[indexPath.section];
    XCCellItem *item = group.items[indexPath.row];
    cell.item = item;
    // 如果不是箭头类型，则不需要选中效果
    if (![item isKindOfClass:[XCArrowItem class]]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    XCCellGroupItem *group = self.groupItems[section];
    return group.footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XCCellGroupItem *group = self.groupItems[section];
    return group.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    XCCellGroupItem *group = self.groupItems[section];
    if (group.footerView) {
        return group.footerView.height;
    } else {
        return 15;
    }
}
    
// FIXME ; header 暂未设置 ！！！
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XCCellGroupItem *group = self.groupItems[indexPath.section];
    XCCellItem *item = group.items[indexPath.row];
    // 如果是箭头类型的,并且没有自己实现block ，进行跳转 。
    if ([item isKindOfClass:[XCArrowItem class]]&&!item.onClicked) {
        XCArrowItem *arrowItem = (XCArrowItem *)item;
        Class cls = NSClassFromString(arrowItem.targetClass);
        UIViewController *baseVC = [[cls alloc] init];
        if (arrowItem.targetClass&&arrowItem.targetClass.length>0) {
//            [[XCRouter sharedInstance] jumpByPath:arrowItem.targetClass isHiddenTabBar:YES];
            [self.navigationController pushViewController:baseVC animated:YES];
        }
    }
    // 如果实现了block，自己去实现跳转逻辑 。
    if (([item isKindOfClass:[XCArrowItem class]]||[item isKindOfClass:[XCLabelItem class]])&&item.onClicked) {
        item.onClicked(item);
    }
}

@end
