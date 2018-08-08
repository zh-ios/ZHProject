//
//  ZHImagePickerController.m
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHImagePickerController.h"
#import "ZHAlbumController.h"
#import "ZHMediaFetcher.h"
@interface ZHImagePickerController ()

@property (nonatomic, strong) ZHMediaFetcher *fetcher;

@end

@implementation ZHImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO init navigation
    [self.fetcher getAlbumsAllowPickVideo:YES pickImage:YES completion:^(NSArray<ZHAlbumModel *> *albums) {
        
    }];
}


- (instancetype)initWithMaxSelectedCount:(NSUInteger)maxCount
                          selectedAssets:(NSArray<ZHAssetModel *> *)selectedAssets
                                delegate:(id)delegate {
    
    self.maxSelectCount = maxCount;
    
    ZHAlbumController *album = [[ZHAlbumController alloc] init];
    self = [super initWithRootViewController:album];
    
    return self;
}


- (instancetype)initWithAssetsList:(NSArray<ZHAssetModel *> *)assets
                    selectedAssets:(NSMutableArray<ZHAssetModel *> *)selectedAssets
                      currentIndex:(NSInteger)index {
    return self;
}

@end
