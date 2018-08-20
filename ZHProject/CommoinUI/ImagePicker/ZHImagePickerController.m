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
#import "ZHPhotoPickerController.h"
@interface ZHImagePickerController ()

@property (nonatomic, strong) ZHMediaFetcher *fetcher;
@property (nonatomic, strong) ZHAlbumController *albumController;

@end

@implementation ZHImagePickerController


- (void)viewDidLoad {
    [super viewDidLoad];
    // TODO init navigation

    self.navigationBar.hidden = YES;

    self.fetcher = [ZHMediaFetcher shareFetcher];
    
    [self initData];
    
    [self requestAlbumAuth];
}

- (void)requestAlbumAuth {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied) {
                [self p_showUnAuthAlert];
            }
            if (status == PHAuthorizationStatusAuthorized) {
                [self.fetcher getAlbumsAllowPickVideo:self.allowPickVideo pickImage:self.allowPickImage completion:^(NSArray<ZHAlbumModel *> *albums) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.albumController.albums = albums;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PHPhotoLibraryAuthStatusChanged" object:nil];
                    });
                }];
            }
        }];
    }
    if (status == PHAuthorizationStatusDenied) {
        [self p_showUnAuthAlert];
    }
}

- (void)p_showUnAuthAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你未设置相册访问权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self.fetcher getAlbumsAllowPickVideo:self.allowPickVideo pickImage:self.allowPickImage completion:^(NSArray<ZHAlbumModel *> *albums) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumController.albums = albums;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PHPhotoLibraryAuthStatusChanged" object:nil];
            });
        }];
    }
}

- (void)initData {
    self.allowPickImage = YES;
    self.allowPickVideo = YES;
}

- (instancetype)initWithMaxSelectedCount:(NSUInteger)maxCount
                          selectedAssets:(NSArray<ZHAssetModel *> *)selectedAssets
                                delegate:(id)delegate {
    
    self.maxSelectCount = maxCount;
    
    ZHAlbumController *album = [[ZHAlbumController alloc] init];
    self.albumController = album;
    self = [super initWithRootViewController:album];
    
    ZHPhotoPickerController *picker = [[ZHPhotoPickerController alloc] init];
    [album.navigationController pushViewController:picker animated:YES];
    
    return self;
}


@end
