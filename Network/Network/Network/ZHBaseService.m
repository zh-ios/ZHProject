//
//  ZHBaseService.m
//  ZHNetWorking
//
//  Created by autohome on 2017/12/5.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "ZHBaseService.h"
#import "ZHTamperGuard.h"
#import "ZHNetworkConst.h"
#import "ZHDNSHttpManager.h"

#define BaseServiceDebugLog(sentence) if(self.enableLog){sentence}

@interface ZHBaseService()<ZHRequestDelegate>

@end

@implementation ZHBaseService

// TODO DNS映射缓存或者定时重发机制

- (instancetype)init {
    if (self = [super init]) {
        [self initProperties];
    }
    return self;
}

#pragma mark --- INIT
- (void)initProperties {
    self.priority = ZHRequest_Priority_Default;
    self.timeoutSeconds = 15;
    self.enableLog = NO;
    self.enableHttpDns = YES;
}

#pragma mark ---SETTER


#pragma mark --- GET 请求
- (void)GET:(NSURL *)url {
    _requestUrlStr = [url absoluteString];
    _requestMethod = @"GET";
    _reallyUrlStr = [url absoluteString];
    
    BaseServiceDebugLog(NSLog(@"原始requstUrl------------------>%@",[url absoluteString]););
    
    NSURL *tempUrl = nil;

    _requestUrlStr = [url absoluteString];
    tempUrl = url;
    [self initGETHttpRequest:url];
}

- (void)initGETHttpRequest:(NSURL *)url {

    [self clearRequest];
    
    ZHRequest *request = [[ZHRequest alloc] init];
    _request = request;
    request.delegate = self;
    request.requestUrlStr = [url absoluteString];
    request.requestHeaders = self.requestHeaderDic;
    request.requestHostType = ZHRequest_HostType_INIT;
    request.requestType = ZHRequest_Type_GET;
    request.timeoutInterval = self.timeoutSeconds;
    request.priority = self.priority;
    self.timeoutRetryTimes = 1;

    request.requestUrlStr = [self getRequestUrl];

    [_request start];
}

- (NSString *)getRequestUrl {
    NSString *requestUlrStr = @"";
    if (self.enableHttpDns) {
        NSString *str = [[ZHDNSHttpManager sharedManager] getIpUrlStrWithReallyUrlStr:_request.requestUrlStr requestUrlStr:_request.requestUrlStr];
        if (!str) { // 还没有走域名解析，直接使用原始域名访问
            requestUlrStr = _request.requestUrlStr;
        }
        if (str && str.length == 0) { // 已经走了域名解析，但是都被标记为失败,使用原始域名
            requestUlrStr = _request.requestUrlStr;
        }
        if (str&&str.length>0) { // ip地址成功替换了域名
            requestUlrStr = str;
            _request.requestHostType = ZHRequest_HostType_DNSPOD;
        }
    } else {
        requestUlrStr = _request.requestUrlStr;
    }
    return requestUlrStr;
}

#pragma mark --- POST 请求
- (void)POST:(NSURL *)url params:(NSDictionary *)params formData:(ConstructingFormDataBlock)formData {
    _requestUrlStr = [url absoluteString];
    _requestMethod = @"POST";
    
}

- (void)POST:(NSURL *)url params:(NSDictionary *)params {
    [self POST:url params:params formData:nil];
}

#pragma mark --- 需要子类实现
- (BOOL)parseJSON:(NSString *)jsonStr {
    return YES;
}

- (void)clearRequest {
    if (self.request) {
        [self.request cancel];
        self.request.delegate = nil;
    }
}

#pragma mark --- ZHRequestDelegate
- (void)requestWillStart {
    if ([self.delegate respondsToSelector:@selector(requestWillStart:serviceObj:)]) {
        [self.delegate requestWillStart:self.handle serviceObj:self];
    }
}
- (void)requestFinished:(ZHRequest *)request responseObj:(id)responseObj {
    if ([self.delegate respondsToSelector:@selector(requestFinished:responseData:serviceObj:handle:)]) {
        [self.delegate requestFinished:request.responseString responseData:request.responseData serviceObj:self handle:self.handle];
        [self parseJSON:request.responseString];
    }
}
- (void)requestFinished:(ZHRequest *)request responseStr:(NSString *)responseStr {
    if ([self.delegate respondsToSelector:@selector(requestFinished:serviceObj:)]) {
        [self.delegate requestFinished:request.responseString serviceObj:self];
        [self parseJSON:request.responseString];
    }
}
- (void)requestFailed:(NSError *)error {
 
    if (error.code == -1009) NSLog(@"---->网络连接失败");
    
    NSUInteger httpCode = self.request.statusCode;
    
    if (httpCode >= 400 && httpCode <= 510 && self.request.requestHostType == ZHRequest_HostType_DNSPOD) { // 400或者500错误
        // 设置ip失效 
        [[ZHDNSHttpManager sharedManager] setIpInvalidate:self.request.requestUrlStr requestUrlStr:self.reallyUrlStr];
    }
    
    // get请求超时重试
    if (error.code == -1001 && self.timeoutRetryTimes > 0 && self.requestMethod == ZHRequest_Type_GET) {
        self.timeoutRetryTimes -= 1;
        _request.requestUrlStr = [self getRequestUrl];
        [_request start];
    }
    // 重试完成之后如果还是失败，再回调业务层error
    if (self.timeoutRetryTimes == 0) {
        if ([self.delegate respondsToSelector:@selector(requestFailed:serviceObj:handle:)]) {
            [self.delegate requestFailed:error serviceObj:self handle:self.handle];
        }
    }
}

@end
