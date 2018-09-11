
//  ViewController.m
//  PerformanceMonitor
//
//  Created by autohome on 2017/6/14.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "ViewController.h"
#import "PerformanceMonitor.h"
#import "TestService.h"
#import "ZHTableViewCell.h"

#import "SXAddScoreView.h"
#import "SXScoreModel.h"
#import "ZZScrollNavigationBar.h"
#import "SettingController.h"
@interface ViewController ()<ZHBaseServiceDelegate,UITableViewDelegate,UITableViewDataSource,ZHImagePickerControllerDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) CADisplayLink *display;
@property(nonatomic, assign) NSTimeInterval lastInterval;

@property(nonatomic, assign) NSInteger fps;
@property(nonatomic, assign) NSInteger count;

@property(nonatomic, strong) dispatch_semaphore_t semmphore;
@property(nonatomic, assign) CFRunLoopActivity activity;
@property(nonatomic, assign) NSInteger timeoutCount;
@property (nonatomic, strong) TestService *service;

@property (nonatomic, strong) NSMutableArray *cellHeightArr;

@property (nonatomic, strong) NSMutableArray *arr;

@property (nonatomic, strong) ZZScrollNavigationBar *bar;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef DEBUG
    [[PerformanceMonitor sharedMonitor] startMonitor];
#endif
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    b.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [b addTarget:self action:@selector(b ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    UIButton *bussines = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    bussines.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.1];
    [bussines addTarget:self action:@selector(bussines ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bussines];
    
    ZZScrollNavigationBar *bar = [[ZZScrollNavigationBar alloc] initWithFrame:CGRectMake(0, 300, 200, 40)];
    bar.titles = @[@"ssss",@"sdfaf",@"sadf"];
    [self.view addSubview:bar];
    [bar reloadData];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 340, self.view.width, 100)];
    scrollView.contentSize = CGSizeMake(self.view.width*bar.titles.count, 0);
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.bar = bar;
    
    SettingController *setting = [[SettingController alloc] init];
    [self.view addSubview:setting.view];
    [self addChildViewController:setting];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.bar targetScollViewDidScroll:scrollView];
}

- (void)bussines {
    TestViewController *test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (void)b {
    ZHImagePickerController *picker = [[ZHImagePickerController alloc] initWithMaxSelectedCount:4 selectedAssets:nil delegate:nil];
    picker.allowPickVideo = YES;
    picker.allowPickImage = YES;
    picker.allowPickOriginalImage = NO;
    [self presentViewController:picker animated:YES completion:nil];
    picker.pickerDelegate = self;
}



- (void)imagePickerController:(ZHImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images imageInfos:(NSArray *)infos {
    for (int i = 0; i<images.count; i++) {
        NSDictionary *dict = infos[i];
        NSLog(@"---%@",dict);
        UIImage *image = images[i];
        NSLog(@"========%@kb", @([UIImagePNGRepresentation(image) length]*1.0/1000));
    }
}

- (void)imagePickerController:(ZHImagePickerController *)picker didFinishPickingOriginalImages:(NSArray<NSData *> *)imagesData imageInfos:(NSArray *)infos {
    
}


- (void)c {
    NSLog(@"cccccc");
}
- (void)tap {
    NSLog(@"tap----");
}

- (void)requestWillStart:(NSInteger)handle
              serviceObj:(id)service {
    
}

- (void)requestFinished:(NSString *)responseStr
           responseData:(NSData *)responseData
             serviceObj:(id)service
                 handle:(NSInteger)handle {
    
}

- (void)requestFailed:(NSError *)error serviceObj:(id)service handle:(NSInteger)handle {
    
}

@end
