//
//  ZHPhotoPickerCollectionCell.m
//  ZHProject
//
//  Created by zh on 2018/8/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPickerCollectionCell.h"


@interface ZHPhotoPickerCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *cantSelectedCoverView;
@property (nonatomic, strong) UIButton *unselectedImageBtn;

@end


@implementation ZHPhotoPickerCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    CGFloat imageViewWH = 18;
    CGFloat padding = 4;
    CGFloat coverBtnWH = 60;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *unselectedImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-padding-imageViewWH, padding, imageViewWH, imageViewWH)];
    self.unselectedImageBtn = unselectedImageBtn;
    unselectedImageBtn.backgroundColor = [UIColor redColor];
    
    [unselectedImageBtn setBackgroundImage:[UIImage imageFromColor:[UIColor redColor]] forState:UIControlStateNormal];
    [unselectedImageBtn setBackgroundImage:[UIImage imageFromColor:[UIColor greenColor]] forState:UIControlStateSelected];

    [self.contentView addSubview:unselectedImageBtn];
    
    
    UIView *cantSelectedCoverView = [[UIView alloc] initWithFrame:self.bounds];
    self.cantSelectedCoverView = cantSelectedCoverView;
    cantSelectedCoverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    cantSelectedCoverView.hidden = YES;
    [self.contentView addSubview:cantSelectedCoverView];
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-60, 0, coverBtnWH, coverBtnWH)];
    [coverBtn addTarget:self action:@selector(coverBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    coverBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:coverBtn];
}

- (void)setModel:(ZHAssetModel *)model {
    _model = model;
    // 说明是选中的
    if (model.selectedIndex != 0 && model.isSelected) {
        
    }
}

- (void)coverBtnOnClick:(UIButton *)btn {
    // TODO model.selected or not selected
    btn.selected = !btn.selected;
    self.model.isSelected = btn.isSelected;
    self.unselectedImageBtn.selected = btn.isSelected;
    if (!self.model.isSelected) {
        self.model.selectedIndex = 0;
    }
    if (self.coverBtnOnClick) {
        self.coverBtnOnClick(self.model);
    }
}

@end
