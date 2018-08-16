//
//  ZHPhotoPreviewController.h
//  ZHProject
//
//  Created by zh on 2018/8/13.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHAssetsModel.h"
@interface ZHPhotoPreviewController : UIViewController


/**
 相册中的所有assets
 */
@property (nonatomic, strong) NSArray<ZHAssetModel *> *assets;

/**
 已经选中的assets
 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
