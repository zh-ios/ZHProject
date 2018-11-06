//
//  ImagePickerController.m
//  ZHProject
//
//  Created by zh on 2018/9/20.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ImagePickerController.h"
#import "ViewController.h"
@interface ImagePickerController ()<ZHImagePickerControllerDelegate>

@end

@implementation ImagePickerController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片选择";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.panGestureEnabled = NO;

    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [selectBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    selectBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(go2ImagePickerVC) forControlEvents:UIControlEventTouchUpInside];
 
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(20, kNavbarHeight+20, 50, 50)];
    [back setTitle:@"跳转到下一个页面" forState:UIControlStateNormal];
    back.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
}

- (void)go {
    [self.navigationController pushViewController:[[ViewController  alloc] init] animated:YES];
}


- (void)go2ImagePickerVC {
    ZHImagePickerController *picker = [[ZHImagePickerController alloc] initWithMaxSelectedCount:9 selectedAssets:nil delegate:self];

    picker.allowPickVideo = YES;
    picker.allowPickImage = YES;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

/**
 ❗️❗️❗️选择非原图图片片回调
 infos 图片信息
 */
- (void)imagePickerController:(ZHImagePickerController *)picker
       didFinishPickingImages:(NSArray<UIImage *> *)images
                   imageInfos:(NSArray *)infos {
    
    for (UIView *view in self.view.subviews) {
        if (view.tag == 200) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat margin = 15;
    CGFloat imgW = (self.view.width-margin*4)/3;
    CGFloat imgH = imgW;

    for (int i = 0; i<images.count; i++) {
        CGFloat x = margin + (margin+imgW)* (i%3);
        CGFloat y = kNavbarHeight+140+margin+(margin+imgH)*(i/3);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imgW, imgH)];
        imageView.image = images[i];
        imageView.tag = 200;
        [self.view addSubview:imageView];
    }
}
/**
 ❗️❗️❗️选择原图图片时回调，返回data类型数据
 PHImageManager的requestImageDataForAsset方法,这个方法是把PhAsset转化为NSData对象,NSData对象可以转化为UIImage对象,
 这样的话可以解决内存暴涨的问题.
 requestImageForAsset会对图片进行渲染,所以导致内存暴涨,
 而requestImageDataForAsset则是直接返回二进制数据,所以内存不会出现暴涨的现象.
 infos 返回的图片信息
 */
- (void)imagePickerController:(ZHImagePickerController *)picker
didFinishPickingOriginalImages:(NSArray<NSData *> *)imagesData
                   imageInfos:(NSArray *)infos {
    
}

@end
