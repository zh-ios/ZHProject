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

+ (void)load {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSString *md5Str =  [@"" MD5Str];
    NSString *str2 =  [@"," encoding];
    
    
    ZHBaseService *ser = [[ZHBaseService alloc] init];
    ser.delegate = self;
    self.ser = ser;
    self.ser.handle = 200;
    [ser GET:[NSURL URLWithString:@"http://www.baidu.com"]];

}


- (void)requestFinished:(NSString *)responseStr serviceObj:(id)service {
    
}

- (void)requestFailed:(NSError *)error serviceObj:(id)service handle:(NSInteger)handle {
    
}


@end
