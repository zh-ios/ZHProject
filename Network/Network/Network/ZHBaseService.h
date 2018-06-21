//
//  ZHBaseService.h
//  ZHNetWorking
//
//  Created by autohome on 2017/12/5.
//  Copyright © 2017年 autohome. All rights reserved.
//  网络请求基类

#import <Foundation/Foundation.h>
#import "ZHBaseServiceDelegate.h"
#import "ZHRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHBaseService : NSObject

@property(nonatomic, weak) id<ZHBaseServiceDelegate> delegate;

/*!
 @property
 @abstract 真是的url 如 https://www.baidu.com 而非ip
 */
@property(nonatomic, copy, readonly) NSString *reallyUrlStr;
/*!
 @property
 @abstract 网络请求服务的标示
 */
@property(nonatomic, assign) NSInteger handle;

/*!
 @property
 @abstract 请求对应的 urlsession 的优先级
 */
@property(nonatomic, assign) ZHRequest_Priority priority;

/** 在 getData 之前进行设置 */
/*!
 @property
 @abstract 是否使用dnspod 目前测试默认为no
 */
@property(nonatomic, assign) BOOL enableHttpDns;

/*!
 @property
 @abstract 是否允许走重试 , 默认是 YES
 */
@property(nonatomic, assign) BOOL enableRetry;

/*!
 @property
 @abstract 超时重试次数 ，只针对get请求 ，post不重试
 */
@property(nonatomic, assign) NSUInteger timeoutRetryTimes;

/*!
 @property
 @abstract 超时时间
 */
@property(nonatomic, assign) NSTimeInterval timeoutSeconds;

/*!
 @property
 @abstract 当前请求的类型 GET ，POST
 */
@property(nonatomic, copy, readonly) NSString *requestMethod;

@property(nonatomic, copy, readonly) NSString *requestUrlStr;

/*!
 @property
 @abstract 服务器返回的数据信息
 */
@property(nonatomic, copy, readonly, nullable) NSString *responseStr;

@property(nonatomic, strong, readonly, nullable) NSData *responseData;
/*!
 @property
 @abstract 是否允许打印日志，默认NO
 */
@property(nonatomic, assign) BOOL enableLog;

@property(nonatomic, copy, nullable) NSDictionary *requestHeaderDic;

@property(nonatomic, strong, readonly) ZHRequest *request;

#pragma mark --- GET 请求相关方法
/*!
 @method
 @abstract   发起GET请求
 @discussion 发起GET请求，使用默认的缓存策略....等策略
 @param      @url 请求url
 */
- (void)GET:(NSURL *)url;


#pragma mark --- POST 请求相关方法
/*!
 @method
 @abstract   发送POST请求
 @param      @url post请求url   params:post请求参数
 */
- (void)POST:(NSURL *)url params:(nullable NSDictionary *)params;

/*!
 @method
 @abstract   发送POST请求，上传文件
 @discussion formData是遵守AFMultipartFormData的对象
 @param      @url 上传url params 参数,formData上传的数据
 */
- (void)POST:(NSURL *)url params:(nullable NSDictionary *)params formData:(nullable ConstructingFormDataBlock)formData;

#pragma mark --- 需要子类实现
/*!
 @method
 @abstract   JSON解析方法
 */
- (BOOL)parseJSON:(NSString *)jsonStr;

// TODO 供子类读取上传进度的方法

@end

NS_ASSUME_NONNULL_END
