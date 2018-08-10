//
//  ZHImagePickerController.h
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"

@protocol ZHImagePickerControllerDelegate <NSObject>



@end


@interface ZHImagePickerController : UINavigationController

// 最大选取数量
@property (nonatomic, assign) NSUInteger maxSelectCount;
// 已经选取的数量
@property (nonatomic, assign) NSInteger  hadSelectedCount;

@property (nonatomic, assign) BOOL allowPickVideo;

@property (nonatomic, assign) BOOL allowPickImage;

- (instancetype)initWithMaxSelectedCount:(NSUInteger)maxCount
                          selectedAssets:(NSArray<ZHAssetModel *> *)selectedAssets
                                delegate:(id)delegate;




/**
 预览图片时使用此方法进行初始化

 @param assets 要预览的图片list
 @param selectedAssets 当前选中的list
 @param index 当前图片的index
 */
- (instancetype)initWithAssetsList:(NSArray<ZHAssetModel *> *)assets
                    selectedAssets:(NSMutableArray<ZHAssetModel *> *)selectedAssets
                      currentIndex:(NSInteger)index;

@end
