//
//  InvocationTool.m
//  Router
//
//  Created by zh on 2018/9/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "InvocationTool.h"

@implementation InvocationTool

+ (NSInvocation *)invocationWithClassName:(NSString *)clsName method:(NSString *)method params:(NSArray *)params {
    SEL sel = NSSelectorFromString(method);
    Class cls = NSClassFromString(clsName);
    if (!cls) return nil;
    NSMethodSignature *signature = [cls instanceMethodSignatureForSelector:sel];
    if (!signature) return nil;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [params enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [invocation setArgument:&obj atIndex:idx+2];
    }];
    [invocation retainArguments];
    return invocation;
}

@end
