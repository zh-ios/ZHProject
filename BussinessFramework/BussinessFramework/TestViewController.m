//
//  TestViewController.m
//  BussinessFramework
//
//  Created by zh on 2018/6/7.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()<ZHBaseServiceDelegate>

@property (nonatomic, strong) ZHBaseService *ser;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    b.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [b addTarget:self action:@selector(b ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    UIButton *bussines = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    bussines.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
    [bussines addTarget:self action:@selector(bussines ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bussines];
    
    NSString *md5Str =  [@"" MD5Str];
    NSString *str2 =  [@"," encoding];
    
    
    ZHBaseService *ser = [[ZHBaseService alloc] init];
    ser.delegate = self;
    self.ser = ser;
    self.ser.handle = 200;
    [ser GET:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    
    UIImage *img = [UIImage imageFromColor:[UIColor orangeColor] size:CGSizeMake(1, 1)];
    
    view.image = [UIImage imageFromColor:[UIColor orangeColor]];
    [self.view addSubview:view];

}

- (void)bussines {
    ZHImagePickerController *picker = [[ZHImagePickerController alloc] initWithMaxSelectedCount:9 selectedAssets:nil delegate:self];
//    Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Pushing a navigation controller is not supported
//    [self.navigationController pushViewController:picker animated:YES];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)b {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFinished:(NSString *)responseStr serviceObj:(id)service {
    
}

- (void)requestFailed:(NSError *)error serviceObj:(id)service handle:(NSInteger)handle {
    
}


@end
