
//  ViewController.m
//  PerformanceMonitor
//
//  Created by autohome on 2017/6/14.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "ViewController.h"
#import "PerformanceMonitor.h"
#import "UIView+extendHitArea.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) CADisplayLink *display;
@property(nonatomic, assign) NSTimeInterval lastInterval;

@property(nonatomic, assign) NSInteger fps;
@property(nonatomic, assign) NSInteger count;

@property(nonatomic, strong) dispatch_semaphore_t semmphore;
@property(nonatomic, assign) CFRunLoopActivity activity;
@property(nonatomic, assign) NSInteger timeoutCount;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

//    PerformanceMonitor *m = [PerformanceMonitor sharedMonitor];
//    [m startMonitor];
//
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    v.backgroundColor = [UIColor redColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [v extendHitArea:100 left:100 bottom:100 right:100];
    v.extendedHitArea = CGRectMake(100, 100, 100, 100);
    [v addGestureRecognizer:tap];
    [self.view addSubview:v];
    
    UIView *v2 = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 202, 202)];
    [v2 extendHitAreaTop:40 left:40 bottom:40 right:40];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(c)];
    [v2 addGestureRecognizer:tap2];
    v2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:v2];

}

- (void)c {
    NSLog(@"cccccc");
}
- (void)tap {
    NSLog(@"tap----");
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"666";
    cell.textLabel.textColor = [UIColor blueColor];
    for (int i = 0; i<100; i++) {
        UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
        [cell.contentView addSubview:v];
        [v removeFromSuperview];
    }
    return cell;
}


@end
