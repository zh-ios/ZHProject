//
//  Platform.h
//  Router
//
//  Created by zh on 2018/9/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, PushAnimation){
    PushAnimation_Right2Left = 0, // 默认从右侧向左侧滑动
    PushAnimation_Bottom2Top, // 从下到上
};

NS_ASSUME_NONNULL_BEGIN

@interface Platform : NSObject


+ (instancetype)sharedPlatform;

- (UIViewController *)viewControllerWithScheme:(NSString *)scheme;

- (void)registerViewControllerWithScheme:(NSString *)scheme
                               targetCls:(NSString *)cls;

- (void)pushViewControllerWithScheme:(NSString *)scheme
                        onController:(UIViewController *)controller
                       animationType:(PushAnimation)type
                                data:(id)data;

- (void)presentViewControllerWithScheme:(NSString *)scheme
                           onController:(UIViewController *)controller
                                   data:(id)data;

@end

NS_ASSUME_NONNULL_END
