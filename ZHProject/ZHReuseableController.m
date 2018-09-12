//
//  ZHReuseableController.m
//  ZHProject
//
//  Created by zh on 2018/9/12.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHReuseableController.h"

@interface ZHReuseableController ()

@property (nonatomic, strong) UILabel *pageL;
@property (nonatomic, strong) UILabel *instanceL;

@end

@implementation ZHReuseableController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 40)];
    self.pageL.textAlignment = NSTextAlignmentCenter;
    self.pageL.textColor = [UIColor orangeColor];
    [self.view addSubview:self.pageL];
    
    self.instanceL = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 40)];
    self.instanceL.textAlignment = NSTextAlignmentCenter;
    self.instanceL.textColor = [UIColor orangeColor];
    [self.view addSubview:self.instanceL];
    
    [self reloadData];
}

- (void)setPage:(NSNumber *)page {
    _page = page;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
//    });
    
}

- (void)reloadData {
    if (self.page) {
        self.pageL.text = [NSString stringWithFormat:@"这是第%@个页面",self.page];
    }
    if (self.instanceName) {
        self.instanceL.text = self.instanceName;
    }
}



@end
