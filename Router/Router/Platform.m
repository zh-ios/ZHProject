//
//  Platform.m
//  Router
//
//  Created by zh on 2018/9/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "Platform.h"

@interface Platform ()

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation Platform

static Platform *_platform = nil;

+ (instancetype)sharedPlatform {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_platform) {
            _platform = [[Platform alloc] init];
        }
    });
    return _platform;
}

- (UIViewController *)viewControllerWithScheme:(NSString *)scheme {
    NSString *clsName = [self.dataDict objectForKey:scheme];
    if (!clsName) return nil;
    UIViewController *vc = (UIViewController *)NSClassFromString(clsName);
    return vc;
}

- (void)registerViewControllerWithScheme:(NSString *)scheme
                               targetCls:(NSString *)cls {
    
    if ([[self.dataDict allKeys] containsObject:scheme]) NSAssert(1, @"scheme不能重复");
    [self.dataDict setObject:cls forKey:scheme];
}










- (void)pushViewControllerWithScheme:(NSString *)scheme
                        onController:(UIViewController *)controller
                       animationType:(PushAnimation)type
                                data:(id)data {
    UIViewController *vc = [self viewControllerWithScheme:scheme];
    if (vc) {
        [controller.navigationController pushViewController:controller animated:YES];
    }
}

- (void)presentViewControllerWithScheme:(NSString *)scheme
                           onController:(UIViewController *)controller
                                   data:(id)data {
    
}

@end
