
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

    self.fetcher = [[ZHMediaFetcher alloc] init];
    
    [self.fetcher getAlbumsAllowPickVideo:YES pickImage:YES completion:^(NSArray<ZHAlbumModel *> *albums) {
        
    }];
    
    self.cellHeightArr = @[].mutableCopy;
    
    for (int i = 0; i<20; i++) {
        [self.cellHeightArr addObject:@(66)];
    }
    
    [self setupTableView];
    
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    b.backgroundColor = [UIColor redColor];
    [b addTarget:self action:@selector(b ) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];


}

- (void)b {
    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *path = [mainBundleDirectory stringByAppendingPathComponent:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSError *err;
    
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    
    NSMutableArray *array = @[].mutableCopy;
    for (NSDictionary *dict in jsonArray[@"data"][@"oneList"]) {
        SXScoreModel *model = [[SXScoreModel alloc] initWithDictionary:dict error:nil];
        [array addObject:model];
    }
    
    SXAddScoreView *view = [[SXAddScoreView alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 300)];
    view.dataArray = array;
    view.finishSelectBlock = ^(SXScoreModel * _Nullable first, SXScoreModel *_Nullable second, SXScoreModel * _Nullable third) {
        
    };
    [view show];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;

    [self.view addSubview:tableView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"sss";
    ZHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ZHTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID  cellFrame:CGRectMake(0, 65.5, self.view.width, 0.5)];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"------%@",@(indexPath.row)];
    
    if (indexPath.row == 2) {
        cell.splitLine.frame = CGRectMake(20, 65.5, [UIScreen mainScreen].bounds.size.width-20*2, 0.5);
    
        cell.splitLine.backgroundColor = [UIColor blueColor];
    } else {
        cell.splitLine.frame = CGRectMake(0, 65.5, self.view.width, 0.5);
        cell.splitLine.backgroundColor = [UIColor orangeColor];
    }
    
    if (indexPath.row == 3) {
        cell.splitLine.hidden = YES;
    } else {
        cell.splitLine.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.cellHeightArr replaceObjectAtIndex:indexPath.row withObject:@(100)];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeightArr[indexPath.row] floatValue];
}




//- (void)b {
//    
//    Class cls = NSClassFromString(@"TestViewController");
//    
//    id view = [[cls alloc] init];
//    
//    [self presentViewController:view animated:YES completion:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//        });
//    }];
//}

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
