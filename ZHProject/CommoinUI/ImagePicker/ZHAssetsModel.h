//
//  ZHAssetsModel.h
//  ZHProject
//
//  Created by zh on 2018/7/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger, ZHAssetMediaType) {
    ZHAssetMediaType_Image = 0,
    ZHAssetMediaType_Video,
    ZHAssetMediaType_Audio,
    ZHAssetMediaType_Gif
};

@interface ZHAssetModel : NSObject


/**
  是否选中
 */
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) id asset; // PHAsset 模型

@property (nonatomic, assign) ZHAssetMediaType type;

+ (instancetype)assetWithType:(ZHAssetMediaType)type;

/**
 video 类型 model初始化
 */
+ (instancetype)assetWithType:(ZHAssetMediaType)type videoDuration:(CGFloat)duration;

@end


@interface ZHAlbumModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) id result; // phfetchResult

@property (nonatomic, strong) NSArray *selectedModels;

+ (instancetype)albumWithResult:(id)result name:(NSString *)name;

@end
