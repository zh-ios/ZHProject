//
//  ZHMediaFetcher.m
//  ZHProject
//
//  Created by zh on 2018/7/31.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHMediaFetcher.h"
#import <Photos/Photos.h>
@implementation ZHMediaFetcher

+ (instancetype)shareFetcher {
    static ZHMediaFetcher *_fetcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_fetcher) {
            _fetcher = [[self alloc] init];
        }
    });
    return _fetcher;
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(ImageFetchedBlock)completed {
    // TODO 添加超长和超宽图片的处理
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    PHImageRequestID imageRequestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        // 是否是缩略图
        BOOL isDegraded = [info objectForKey:PHImageResultIsDegradedKey];
        
        if (completed) {
            completed(result, info);
        }
    }];
    return imageRequestId;
}

- (void)getImageForAssetModel:(ZHAssetModel *)asset imageSize:(CGSize)size completion:(ImageFetchedBlock)completed {
    
}




- (void)getAssetsForResult:(PHFetchResult *)result allowPickVideo:(BOOL)pickVideo
            allowPickImage:(BOOL)pickImage completion:(AssetsFetchedBlock)completed {
    
    NSMutableArray *assetsArray = @[].mutableCopy;
    [result enumerateObjectsUsingBlock:^(PHAsset *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZHAssetModel *model = [self p_getAssetModelForAsset:obj allowPickVideo:pickVideo allowPickImage:pickImage];
        if (model) {
            [assetsArray addObject:model];
        }
    }];
    if (completed) {
        completed(assetsArray);
    }
}

- (void)getAlbumsAllowPickVideo:(BOOL)pickVideo pickImage:(BOOL)pickImage completion:(AlbumsFetchedBlock)completed {
    
    NSMutableArray *albumsArr = @[].mutableCopy;
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!pickVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!pickImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                PHAssetMediaTypeVideo];
    // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:self.sortAscendingByModificationDate]];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    
    
    // 我的照片流 1.6.10重新加入..
    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    NSArray *allAlbums = @[myPhotoStreamAlbum,smartAlbums,topLevelUserCollections,syncedAlbums,sharedAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            // 有可能是PHCollectionList类的的对象，过滤掉
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            // 过滤空相册
            if (collection.estimatedAssetCount <= 0) continue;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if (fetchResult.count > 1) {
                ZHAlbumModel *model = [ZHAlbumModel modelWithResult:fetchResult name:collection.localizedTitle];
                [albumsArr addObject:model];
                
                [self getPosterImageForAlbumModel:model completion:^(UIImage *image, NSDictionary *info) {
                    
                }];
            }
        }
    }
    
    if (completed) {
        completed(albumsArr);
    }
}


- (void)getPosterImageForAlbumModel:(ZHAlbumModel *)album completion:(ImageFetchedBlock)completed {
    // TODO 根据排序规则，选择是最后一个还是第一个
    PHAsset *lastAsset = [album.result lastObject];
    [self requestImageForAsset:lastAsset targetSize:CGSizeMake(80, 80) completion:^(UIImage *image, NSDictionary *info) {
        if (completed) {
            completed(image, info);
        }
    }];
}


- (ZHAssetModel *)p_getAssetModelForAsset:(PHAsset *)asset allowPickVideo:(BOOL)pickVideo allowPickImage:(BOOL)pickImage {
    ZHAssetModel *model = nil;
    ZHAssetMediaType type = [self p_getMediaTypeForAsset:asset];
    if (!pickVideo && type == ZHAssetMediaType_Video) return nil;
    if (!pickImage && (type == ZHAssetMediaType_Image || type == ZHAssetMediaType_Gif)) return nil;
    if (type == ZHAssetMediaType_Audio) return nil;
    
    if (type == ZHAssetMediaType_Video) {
        CGFloat duration = asset.duration;
        model = [ZHAssetModel modelWithAsset:asset type:ZHAssetMediaType_Video videoDuration:duration];
        return model;
    } else {
        model = [ZHAssetModel modelWithAsset:asset type:type];
    }
    return model;
}



- (ZHAssetMediaType)p_getMediaTypeForAsset:(PHAsset *)asset {
    ZHAssetMediaType type = ZHAssetMediaType_Image;
    if (asset.mediaType == PHAssetMediaTypeVideo)  type = ZHAssetMediaType_Video;
    if (asset.mediaType == PHAssetMediaTypeAudio) type = ZHAssetMediaType_Audio;
    if (asset.mediaType == PHAssetMediaTypeImage) {
        if ([[[asset valueForKey:@"filename"] uppercaseString] isEqualToString:@"GIF"]) {
            type = ZHAssetMediaType_Gif;
        }
    }
    return type;
}

@end
