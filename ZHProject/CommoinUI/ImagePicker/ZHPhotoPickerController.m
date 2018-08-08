//
//  ZHPhotoPickerController.m
//  ZHProject
//
//  Created by zh on 2018/8/8.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHPhotoPickerController.h"
#import "ZHPhotoPickerCollectionCell.h"

@interface ZHPhotoPickerController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ZHPhotoPickerController

#define kCollectionViewColumnCount          (4)
#define kCollectionViewItemMargin           (8)

static NSString *collectionCellID = @"photopickercollectionviewcellID";

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 8;
        _layout.minimumInteritemSpacing = 8;
        CGFloat itemWH = (self.view.width-kCollectionViewItemMargin*(kCollectionViewColumnCount-1))/kCollectionViewColumnCount;
        _layout.itemSize = CGSizeMake(itemWH,itemWH);
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, self.view.height-kNavbarHeight-kBottomSafeArea) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZHPhotoPickerCollectionCell class] forCellWithReuseIdentifier:collectionCellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHPhotoPickerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    ZHAssetModel *model = self.assets[indexPath.item];
    cell.model = model;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

@end
