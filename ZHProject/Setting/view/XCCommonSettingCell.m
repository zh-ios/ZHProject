//
//  XCCommonSettingCell.m
//  XChatProject
//
//  Created by zh on 2018/7/3.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "XCCommonSettingCell.h"
#import "XCSettingCellContainerView.h"
@interface XCCommonSettingCell ()

@property (nonatomic, strong) XCSettingCellContainerView *containerView;

@end

@implementation XCCommonSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    // width 取屏幕宽，这个是拿到的width是320 。
    self.containerView = [[XCSettingCellContainerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height)];
    [self.contentView addSubview:self.containerView];
}

- (void)setItem:(XCCellItem *)item {
    _item = item;
    self.containerView.item = item;
}

@end
