
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
#import "ZHMediaFetcher.h"
#import "SXAddScoreView.h"
#import "SXScoreModel.h"

#import "ZHImagePickerController.h"

@interface ViewController ()<ZHBaseServiceDelegate,UITableViewDelegate,UITableViewDataSource>

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
@property (nonatomic, strong) ZHMediaFetcher *fetcher;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];    

    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    b.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [b addTarget:self action:@selector(b ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];

    
    
   
    

}

- (void)b {
    ZHImagePickerController *picker = [[ZHImagePickerController alloc] initWithMaxSelectedCount:4 selectedAssets:nil delegate:nil];
    [self presentViewController:picker animated:YES completion:nil];
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

//- (void)requestFinished:(NSString *)responseStr serviceObj:(id)service {
//    
//}

- (void)requestFailed:(NSError *)error serviceObj:(id)service handle:(NSInteger)handle {
    
}

@end
