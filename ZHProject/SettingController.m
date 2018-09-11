//
//  SettingController.m
//  ZHProject
//
//  Created by zh on 2018/9/7.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SettingController.h"
#import "ScrollNavigationController.h"
@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    XCArrowItem *item1 = [XCArrowItem itemWithIcon:nil title:@"滚动bar" targetCls:@"ScrollNavigationController"];
    XCCellGroupItem *group = [XCCellGroupItem itemWithItems:@[item1]];
    self.groupItems = @[group];
    __weak typeof(self)weakSelf = self;
    item1.onClicked = ^(XCCellItem *item) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController pushViewController:[[ScrollNavigationController alloc] init] animated:YES];
    };
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    headerView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
    group.headerView = headerView;
    [self reloadData];
    
}




@end
