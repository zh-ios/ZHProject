//
//  PerformanceMonitor.m
//  PerformanceMonitor
//
//  Created by autohome on 2017/6/15.
//  Copyright © 2017年 autohome. All rights reserved.
//

#import "PerformanceMonitor.h"
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>



@interface PerformanceMonitor ()

@property(nonatomic, strong) CADisplayLink *display;
@property(nonatomic, assign) NSTimeInterval lastInterval;

@property(nonatomic, assign) NSInteger fps;
@property(nonatomic, assign) NSInteger count;

@property(nonatomic, strong) dispatch_semaphore_t semmphore;
@property(nonatomic, assign) CFRunLoopActivity activity;
@property(nonatomic, assign) NSInteger timeoutCount;

@property(nonatomic, strong) dispatch_source_t timer;

@property(nonatomic, strong) UILabel *fpsL;
@property(nonatomic, strong) UILabel *cpuL;
@property(nonatomic, strong) UIView *monitorView;
@property(nonatomic, strong) UILabel *memoryL;
@property(nonatomic, assign) CGPoint originalPoint;

@end

@implementation PerformanceMonitor

+ (instancetype)sharedMonitor {
    static PerformanceMonitor *monitoer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (monitoer == nil) {
            monitoer = [[self alloc] init];
        }
    });
    return monitoer;
}

- (instancetype)init {
    if (self = [super init]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setupMonitoerView];
        });
    }
    return self;
}

- (void)setLableProperty:(UILabel *)label {
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor greenColor];
}

- (void)setupMonitoerView {
    CGFloat labelH = 15;
    UIView *monitorView = [[UIView alloc] initWithFrame:CGRectMake(5, 20, 60, labelH*3)];
    self.originalPoint = monitorView.frame.origin;
    monitorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMonitorView:)];
    // 监听手势状态变化
    [pan addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    [monitorView addGestureRecognizer:pan];
    
    UILabel *fpsL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, monitorView.frame.size.width, labelH)];
    UILabel *cpuL = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, monitorView.frame.size.width, labelH)];
    UILabel *memoryL = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, monitorView.bounds.size.width, labelH)];

    self.monitorView = monitorView;
    self.fpsL = fpsL;
    self.cpuL = cpuL;
    self.memoryL = memoryL;

    [monitorView addSubview:fpsL];
    [monitorView addSubview:cpuL];
    [monitorView addSubview:memoryL];
    
    [self setLableProperty:fpsL];
    [self setLableProperty:cpuL];
    [self setLableProperty:memoryL];

    [[UIApplication sharedApplication].keyWindow addSubview:monitorView];
}

- (void)panMonitorView:(UIPanGestureRecognizer *)pan {
    CGPoint translatePoint = [pan translationInView:self.monitorView];
    self.monitorView.frame = CGRectMake(self.originalPoint.x+translatePoint.x, self.originalPoint.y+translatePoint.y,self.monitorView.frame.size.width,self.monitorView.frame.size.height);
}

- (void)startMonitor {
    // 监控帧率
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    self.display = displaylink;
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    self.semmphore = dispatch_semaphore_create(0);
    self.timeoutCount = 0;
    
    // 监控卡顿
    // runloop 运行上下文环境
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runloopObserver, &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            // zero = success else timeout
            // // 假定连续5次超时30ms认为卡顿(当然也包含了单次超时250ms)
            // Returns zero on success, or non-zero if the timeout occurred
            long state = dispatch_semaphore_wait(self.semmphore, dispatch_time(DISPATCH_TIME_NOW, 30*NSEC_PER_MSEC));
            if (state != 0) {
                if (self.activity == kCFRunLoopBeforeSources || self.activity == kCFRunLoopAfterWaiting) {
                    self.timeoutCount += 1;
                    if (self.timeoutCount < 5) {
                        continue;
                    } else {
                        NSLog(@"🍉🍉🍉🍉🍉🍉🍉可能超时了");
                        self.timeoutCount = 0;
                        // 这里可以记录当前的堆栈信息
                    }
                }
            }
            self.timeoutCount = 0;
        }
    });
    
    // 打印cpu使用率
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    self.timer = timer;
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1000*NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        CGFloat cpuUsage = [self cpu_usage];
        CGFloat memoryUsage = [self memoryUsage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cpuL.text = [NSString stringWithFormat:@"cpu:%d%%",(int)(cpuUsage*100)];
            if (cpuUsage>0&&cpuUsage<0.3) {
                self.cpuL.textColor = [UIColor  greenColor];
            } else if (cpuUsage>=0.3&&cpuUsage<0.5) {
                self.cpuL.textColor = [UIColor yellowColor];
            } else {
                self.cpuL.textColor = [UIColor redColor];
            }
            self.memoryL.text = [NSString stringWithFormat:@"m:%.2f",memoryUsage];
            if (memoryUsage<100) {
                self.memoryL.textColor = [UIColor greenColor];
            } else if (memoryUsage>=100&&memoryUsage<150) {
                self.memoryL.textColor = [UIColor yellowColor];
            } else {
                self.memoryL.textColor = [UIColor redColor];
            }
        });
    });
    dispatch_resume(timer);
}



/*!
 @abstract   runloop 监听回调
 */
static void runloopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    //    NSLog(@"-------%ld",activity);
    
    PerformanceMonitor *moniotr = (__bridge PerformanceMonitor*)info;
    
    moniotr.activity = activity;
    
    dispatch_semaphore_signal(moniotr.semmphore);
}

/*!
    定时器回调
 */
- (void)handleDisplayLink:(CADisplayLink *)link {
    if (self.lastInterval == 0) {
        self.lastInterval = link.timestamp;
        return;
    }
   
    self.count++;
    NSTimeInterval interval = link.timestamp;
    // 每隔一秒记录一次
    NSTimeInterval delta = interval - self.lastInterval;
    if (delta < 1) {
        return;
    }
    self.lastInterval = link.timestamp;
    self.fps = self.count / delta;
    self.fpsL.text = [NSString stringWithFormat:@"fps:%@",@(self.fps)];
    self.count = 0;
    if (self.fps>=50) {
        self.fpsL.textColor = [UIColor greenColor];
    } else {
        self.fpsL.textColor = [UIColor redColor];
    }
}


- (unsigned long)memoryUsage {
    mach_task_basic_info_data_t taskInfo;
    unsigned infoCount = sizeof(taskInfo);
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         MACH_TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size_max / 1024.0 / 1024.0;
}

- (float)cpu_usage {
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    return tot_cpu;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        NSUInteger stateValue = [change[@"new"] integerValue];

        BOOL begin = (stateValue == UIGestureRecognizerStateBegan);
        if (begin) {
            // 开始移动时更新起始点坐标
            self.originalPoint = self.monitorView.frame.origin;
        }
        BOOL ended = (stateValue == UIGestureRecognizerStateEnded);
        
        if (ended) {
            // 注：delay一段时间，因为在监听到状态ended之后还会再调用panMonitorView方法
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGFloat X = self.monitorView.frame.origin.x;
                if (X < [UIScreen mainScreen].bounds.size.width*0.5-self.monitorView.bounds.size.width*0.5) {
                    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.monitorView.frame = CGRectMake(0, self.monitorView.frame.origin.y,self.monitorView.bounds.size.width,self.monitorView.bounds.size.height);
                    } completion:nil];
                } else {
                    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.monitorView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-self.monitorView.bounds.size.width, self.monitorView.frame.origin.y,self.monitorView.bounds.size.width,self.monitorView.bounds.size.height);
                    } completion:nil];
                }
            });
        }
    }
}

/////  网络总流量监控
/**
 *  WiFiSent WiFi发送流量
 *  WiFiReceived WiFi接收流量
 *  WWANSent 移动网络发送流量
 *  WWANReceived 移动网络接收流量
 */
+ (NSDictionary *)getTrafficMonitorings {
    NSDictionary * trafficDict = [[NSDictionary alloc] init];
    BOOL success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    NSString *name=[[NSString alloc]init];
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            
            if (cursor->ifa_addr->sa_family == AF_LINK) {
                //wifi消耗流量
                if ([name hasPrefix:@"en"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                }
                
                //移动网络消耗流量
                if ([name hasPrefix:@"pdp_ip0"]) {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    NSString *WiFiSentTraffic = [NSString stringWithFormat:@"%d",WiFiSent];
    NSString *WiFiReceivedTraffic = [NSString stringWithFormat:@"%d",WiFiReceived];
    NSString *WiFiTotalTraffic = [NSString stringWithFormat:@"%d",WiFiSent + WiFiReceived];
    NSString *WWANSentTraffic = [NSString stringWithFormat:@"%d",WWANSent];
    NSString *WWANReceivedTraffic = [NSString stringWithFormat:@"%d",WWANReceived];
    NSString *WWANTotalTraffic = [NSString stringWithFormat:@"%d",WWANSent+WWANReceived];
    trafficDict = @{
                    @"WiFiSentTraffic":WiFiSentTraffic,
                    @"WiFiReceivedTraffic":WiFiReceivedTraffic,
                    @"WiFiTotalTraffic":WiFiTotalTraffic,
                    @"WWANSentTraffic":WWANSentTraffic,
                    @"WWANReceivedTraffic":WWANReceivedTraffic,
                    @"WWANTotalTraffic":WWANTotalTraffic
                    };
    
    return trafficDict;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"state"];
}

@end
