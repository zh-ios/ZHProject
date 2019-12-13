//
//  SettingController.m
//  ZHProject
//
//  Created by zh on 2018/9/7.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SettingController.h"
#import "ScrollNavigationController.h"
#import "CycleScollController.h"
#import "ImagePickerController.h"
#import "ZHPopDownMenu.h"
@interface SettingController ()

@property (nonatomic, strong) ZHPopDownMenu *m ;

@end

@implementation SettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)b:(UIButton *)b {
    ZHPopDownMenu *m = [[ZHPopDownMenu alloc] init];
//    self.m = m;
//    [m showMenuUnderView:b titles:@[@"sssss",@"aaaaa",@"ssss",@"cccc"] images:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"哈哈护手霜";
    
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    [self.view addSubview:b];
    b.backgroundColor = [ UIColor redColor];
    [b addTarget:self action:@selector(b:) forControlEvents:UIControlEventTouchUpInside];
    
    
    XCArrowItem *item1 = [XCArrowItem itemWithIcon:nil title:@"滚动bar" targetCls:nil];
    
    __weak typeof(self)weakSelf = self;
    item1.onClicked = ^(XCCellItem *item) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.navigationController pushViewController:[[ScrollNavigationController alloc] init] animated:YES];
    };
  
    XCArrowItem *item3 = [XCArrowItem itemWithIcon:nil title:@"循环滚动视图" targetCls:nil];
    item3.onClicked = ^(XCCellItem *item) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CycleScollController *cycle = [[CycleScollController alloc] init];
        cycle.animationType = NaviAnimationType_Bottom2Top;
        cycle.hidesBottomBarWhenPushed = YES;
        cycle.title = @"循环滚动视图";
        [strongSelf.navigationController pushViewController:cycle animated:YES];
    };
    
    XCArrowItem *item4 = [XCArrowItem itemWithIcon:nil title:@"图片选择" targetCls:nil];
    item4.onClicked = ^(XCCellItem *item) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        ImagePickerController *picker = [[ImagePickerController alloc] init];
        picker.hidesBottomBarWhenPushed = YES;
        picker.title = @"图片选择";
        [strongSelf.navigationController pushViewController:picker animated:YES];
    };
    
    XCCellGroupItem *group = [XCCellGroupItem itemWithItems:@[item1,item3,item4]];
    self.groupItems = @[group];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    headerView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
    group.headerView = headerView;
    [self reloadData];
    
    
    
}



@end
