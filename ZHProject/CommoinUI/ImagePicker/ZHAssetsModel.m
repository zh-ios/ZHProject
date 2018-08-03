//
//  ZHAssetsModel.m
//  ZHProject
//
//  Created by zh on 2018/7/30.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHAssetsModel.h"

@implementation ZHAssetModel



@end


@implementation ZHAlbumModel

+ (instancetype)albumWithResult:(id)result name:(NSString *)name {
    return [[self alloc] initWithAlbumWithResult:result name:name];
}

- (instancetype)initWithAlbumWithResult:(id)result name:(NSString *)name {
    if (self = [super init]) {
        self.result = result;
        self.name = name;
        self.count = [(PHFetchResult *)result count];
    }
    return self;
}

@end
