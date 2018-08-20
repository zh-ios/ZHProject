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
    self.interactivePopGestureRecognizer.enabled = NO;
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PHPhotoLibraryOnGetAlbumData" object:nil];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self currentVC] presentViewController:alert animated:YES completion:nil];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [self.fetcher getAlbumsAllowPickVideo:self.allowPickVideo pickImage:self.allowPickImage completion:^(NSArray<ZHAlbumModel *> *albums) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumController.albums = albums;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PHPhotoLibraryOnGetAlbumData" object:nil];
            });
        }];
    }
}

/**
 获取当前控制器
 */
- (UIViewController *)currentVC {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *controller = window.rootViewController;
    while (YES) {
        if (controller.presentedViewController) {
            controller = controller.presentedViewController;
        } else {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                controller = [controller.childViewControllers lastObject];
            } else if ([controller isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tabBarController = (UITabBarController *)controller;
                controller = tabBarController.selectedViewController;
            } else {
                if (controller.childViewControllers.count > 0) {
                    controller = [controller.childViewControllers lastObject];
                } else {
                    return controller;
                }
            }
        }
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
