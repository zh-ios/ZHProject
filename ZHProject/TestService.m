
//
//  TestService.m
//  ZHProject
//
//  Created by zh on 2018/6/20.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "TestService.h"

@implementation TestService

- (void)getData {
      NSString *localpushurl = @"https://activity.app.autohome.com.cn/ugapi/api/localpush/getLocalPush?deviceid=sssssssssaas1sss3123sdfasssssdfasdf&flag=";

    self.timeoutSeconds = 1;
    [self GET:[NSURL URLWithString:localpushurl]];
}

- (BOOL)parseJSON:(NSString *)jsonStr {
    
    NSLog(@"------------>%@",jsonStr);
    
    return YES;
}

@end
