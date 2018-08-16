//
//  ZHPhotoPickerController.m
//  ZHProject
//
//  Created by zh on 2018/8/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPickerController.h"
#import "ZHPhotoPickerCollectionCell.h"
#import "ZHMediaFetcher.h"
#import "ZHImagePickerController.h"
#import "ZHImagePickerConst.h"
#import "ZHPhotoPreviewController.h"
@interface ZHPhotoPickerController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray<ZHAssetModel *> *assets;
@property (nonatomic, weak) ZHImagePickerController  *imagePickerVC;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIButton *previewBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) BOOL isSlectedOriginalImage;

@end

@implementation ZHPhotoPickerController

#define kCollectionViewColumnCount          (4)
#define kCollectionViewItemMargin           (4)

static NSString *collectionCellID = @"photopickercollectionviewcellID";

- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = @[].mutableCopy;
    }
    return _selectedAssets;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = kCollectionViewItemMargin;
        _layout.minimumInteritemSpacing = kCollectionViewItemMargin;
        CGFloat itemWH = (self.view.width-kCollectionViewItemMargin*2-kCollectionViewItemMargin*(kCollectionViewColumnCount-1))/kCollectionViewColumnCount;
        
        _layout.itemSize = CGSizeMake(itemWH,itemWH);
        _layout.sectionInset = UIEdgeInsetsMake(kCollectionViewItemMargin, kCollectionViewItemMargin,
                                                kCollectionViewItemMargin, kCollectionViewItemMargin);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kNavbarHeight,
                                                                             self.view.width, self.view.height-kNavbarHeight-kBottomSafeArea-50) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ZHPhotoPickerCollectionCell class]
            forCellWithReuseIdentifier:collectionCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.imagePickerVC = (ZHImagePickerController *)self.navigationController;
    
    [[ZHMediaFetcher shareFetcher] getAssetsForResult:self.album.result allowPickVideo:self.imagePickerVC.allowPickVideo allowPickImage:self.imagePickerVC.allowPickImage completion:^(NSArray<ZHAssetModel *> *assets) {
        self.assets = assets;
        [self.collectionView reloadData];
    }];
    
    [self.view addSubview:self.collectionView];

    [self initCustomNav];
    [self initBottomBar];
}

- (void)initCustomNav {
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavbarHeight)];
    nav.backgroundColor = kImagePickerNavBgColor;
    [self.view addSubview:nav];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, kTopSafeArea+10, 200, 20)];
    titleL.font = kImagePickerNavTitleFont;
    titleL.textColor = kImagePickerNavTextColor;
    [nav addSubview:titleL];
    titleL.text = self.album.name;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kImagePickerSideViewPadding, kTopSafeArea+10, 20, 20)];
    backBtn.backgroundColor = [UIColor orangeColor];
    [backBtn setExtendedHitArea:CGRectMake(20, 20, 20, 20)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:backBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-kImagePickerSideViewPadding-30, kTopSafeArea+10, 20, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = kImagePickerNavRightViewTextFont;
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:cancelBtn];
}

- (void)initBottomBar {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-kBottomSafeArea-50, self.view.width, kBottomSafeArea+50)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:bottomView];
    
    UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(kImagePickerSideViewPadding, 0, 40, bottomView.height)];
    [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
    previewBtn.enabled = NO;
    previewBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [previewBtn setTitleColor:[UIColor colorWithHexString:@"343434"] forState:UIControlStateNormal];
    [previewBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:previewBtn];
    
    UIButton *originalBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, bottomView.height)];
    originalBtn.centerX = bottomView.centerX;
    [originalBtn setImage:[UIImage imageFromColor:[UIColor orangeColor] size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [originalBtn setImage:[UIImage imageFromColor:[UIColor redColor] size:CGSizeMake(20, 20)] forState:UIControlStateSelected];
    [originalBtn setTitle:@"原图" forState:UIControlStateNormal];
    originalBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    originalBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [originalBtn addTarget:self action:@selector(originalBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:originalBtn];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-kImagePickerSideViewPadding-60, 10, 60, 30)];
    [sendBtn setBackgroundImage:[UIImage imageFromColor:[UIColor yellowColor] size:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    [sendBtn setBackgroundImage:[UIImage imageFromColor:[UIColor orangeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    sendBtn.enabled = NO;
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendBtn];
    
    self.previewBtn = previewBtn;
    self.sendBtn = sendBtn;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHPhotoPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    ZHAssetModel *model = self.assets[indexPath.item];
    if (model.isSelected) {
        model.selectedIndex = [self.selectedAssets indexOfObject:model];
    }
    cell.model = model;
    // 点击了右上角回调
    __weak typeof(self)weakSelf = self;
    cell.coverBtnOnClick = ^(ZHAssetModel * _Nonnull model) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf cellCoverBtnOnClick:model indexPath:indexPath];
    };
    if (self.imagePickerVC.hadSelectedCount+self.selectedAssets.count>=self.imagePickerVC.maxSelectCount) {
        cell.cantSelectedCoverView.hidden = model.isSelected;
    } else {
        cell.cantSelectedCoverView.hidden = YES;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZHPhotoPreviewController *preview = [[ZHPhotoPreviewController alloc] init];
    preview.selectedIndex = indexPath.item;
    preview.assets = self.assets;
    // 直接传引用，在预览页面数组改变这里的也会发生变化
    preview.selectedAssets = self.selectedAssets;
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)cellCoverBtnOnClick:(ZHAssetModel *)model indexPath:(NSIndexPath *)indexPath {
    if (!model.isSelected) { // 如果当前模型未选中，则点击后将处于选中状态，判断是否超过最大选择张数
        BOOL allowChoose = (self.selectedAssets.count+self.imagePickerVC.hadSelectedCount) < self.imagePickerVC.maxSelectCount;
        if (!allowChoose) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多只能选取%@张照片",@(self.imagePickerVC.maxSelectCount)] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
    }
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.selectedAssets addObject:model];
        model.selectedIndex = self.selectedAssets.count;
    } else {
        [self.selectedAssets removeObject:model];
        [self.selectedAssets enumerateObjectsUsingBlock:^(ZHAssetModel *asset, NSUInteger idx, BOOL * _Nonnull stop) {
            asset.selectedIndex = idx;
        }];
    }
    // FIXME : 局部刷新即可
    [self.collectionView reloadData];
    [self refreshBottomBar];
}


/**
  刷新底部视图
 */
- (void)refreshBottomBar {
    self.previewBtn.enabled = self.selectedAssets.count > 0;
    self.sendBtn.enabled = self.selectedAssets.count > 0;
    NSString *sendBtnTitle = self.selectedAssets.count > 0 ? [NSString stringWithFormat:@"发送(%@)",@(self.selectedAssets.count)] : @"发送";
    [self.sendBtn setTitle:sendBtnTitle forState:UIControlStateNormal];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel {
    // FIXME: 回调
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)preview {
    ZHPhotoPreviewController *preview = [[ZHPhotoPreviewController alloc] init];
    preview.selectedIndex = 0;
    preview.assets = [self.selectedAssets copy] ;
    // 直接传引用，在预览页面数组改变这里的也会发生变化
    preview.selectedAssets = self.selectedAssets;
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)originalBtnOnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.isSlectedOriginalImage = btn.selected;
}

- (void)send {
    
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"---- 图片选择页面销毁了");
#endif
}

@end
