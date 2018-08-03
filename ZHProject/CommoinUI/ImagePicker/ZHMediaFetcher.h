//
//  ZHMediaFetcher.h
//  ZHProject
//
//  Created by zh on 2018/7/31.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHAssetsModel.h"

/**
 获取到图片后的回调block

 @param image 选择的图片
 @param info info
 */
typedef void (^ImageFetchedBlock)(UIImage *image, NSDictionary *info);
typedef void (^AlbumsFetchedBlock)(NSArray<ZHAlbumModel *> *albums);
typedef void (^AssetsFetchedBlock)(NSArray<ZHAssetModel *> *assets);

@interface ZHMediaFetcher : NSObject



/**
 获取相册的封面图

 @param album ZHAlbumModel
 @param completed 完成回调
 */
- (void)getPosterImageForAlbumModel:(ZHAlbumModel *)album completion:(ImageFetchedBlock)completed;


/**
 通过PHFetchResult 获取AssetMode
 @param completed 回去完成回调
 */
- (void)getAssetsForResult:(PHFetchResult *)result allowPickVideo:(BOOL)pickVideo allowPickImage:(BOOL)pickImage completion:(AssetsFetchedBlock)completed;


- (void)getImageForssetModel:(ZHAssetModel *)asset imageSize:(CGSize)size completion:(ImageFetchedBlock)completed;

- (void)getAlbumsAllowPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage completion:(AlbumsFetchedBlock)completed;


- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(ImageFetchedBlock)completed;

//requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

@end
