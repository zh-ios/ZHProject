//
//  ZHBaseServiceDelegate.h
//  ZHNetWorking
//
//  Created by autohome on 2017/12/5.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZHBaseServiceDelegate <NSObject>



/**
 请求将要开始回调

 @param handle service的唯一标识(在创建service时传递的值 。如：service.handle=10000)
 @param service 当前service
 */
- (void)requestWillStart:(NSInteger)handle
              serviceObj:(id)service;


/**
 请求成功回调,按需要写一个成功的回调即可，否则会调用两次 - parseJSON 方法 。

 @param responseStr 结果字符串
 @param service service
 */
- (void)requestFinished:(NSString *)responseStr
             serviceObj:(id)service;

/**
 请求成功回调

 @param responseStr 结果字符串
 @param responseData 结果二进制格式数据
 @param service service
 @param handle 请求的标识
 */
- (void)requestFinished:(NSString *)responseStr
           responseData:(NSData *)responseData
             serviceObj:(id)service
                 handle:(NSInteger)handle;


/**
 请求失败回调

 @param error error
 @param service service
 @param handle 请求标识
 */
- (void)requestFailed:(NSError *)error
           serviceObj:(id)service
               handle:(NSInteger)handle;


- (void)requestWillRetry:(id)service handle:(NSInteger)handle isAsync:(BOOL)async;


- (void)requestRedirected:(id)service handle:(NSInteger)handle;

@end
