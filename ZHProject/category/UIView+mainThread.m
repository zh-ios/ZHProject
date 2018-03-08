//
//  UIView+mainThread.m
//  PerformanceMonitor
//
//  Created by autohome on 2018/3/6.
//  Copyright © 2018年 autohome. All rights reserved.
//  检测view展示是否在主线程中进行

#import "UIView+mainThread.h"
#import <objc/runtime.h>
@implementation UIView (mainThread)


+ (void)swzMethod:(Class)cls originalM:(SEL)originalSEL swzM:(SEL)swzSEL {
    Method oriM = class_getInstanceMethod(cls, originalSEL);
    Method swzM = class_getInstanceMethod(cls, swzSEL);
    IMP swzIMP = method_getImplementation(swzM);
    IMP oriIMP = method_getImplementation(oriM);
//    IMP swzIMP = class_getMethodImplementation(cls, swzSEL);
    
    //        " 周全起见，有两种情况要考虑一下。第一种情况是要复写的方法(overridden)并没有在目标类中实现(notimplemented)，而是在其父类中实现了。第二种情况是这个方法已经存在于目标类中(does existin the class itself)。这两种情况要区别对待。 (译注: 这个地方有点要明确一下，它的目的是为了使用一个重写的方法替换掉原来的方法。但重写的方法可能是在父类中重写的，也可能是在子类中重写的。) 对于第一种情况，应当先在目标类增加一个新的实现方法(override)，然后将复写的方法替换为原先(的实现(original one)。 对于第二情况(在目标类重写的方法)。
    BOOL addSuccess = class_addMethod(cls, originalSEL, swzIMP, method_getTypeEncoding(swzM));
    if (addSuccess) {
        class_replaceMethod(cls, swzSEL, oriIMP, method_getTypeEncoding(oriM));
    } else {
        method_exchangeImplementations(oriM, swzM);
    }
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL layoutSEL = @selector(setNeedsDisplay);
        SEL swzLayoutSEL = @selector(swz_setNeedsLayout);
        [self swzMethod:[self class] originalM:layoutSEL swzM:swzLayoutSEL];
        
        SEL displaySEL = @selector(setNeedsDisplay);
        SEL swzDisplaySEL = @selector(swz_setNeedsDisplay);
        [self swzMethod:[self class] originalM:displaySEL swzM:swzDisplaySEL];
        
        SEL inRectSEL = @selector(setNeedsDisplayInRect:);
        SEL swzInRectSEL = @selector(swz_setNeedsDisplayInRect:);
        [self swzMethod:[self class] originalM:inRectSEL swzM:swzInRectSEL];
    });
}

// 调用originalSEL，执行的是下面的代码实现
- (void)swz_setNeedsLayout {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsLayout];
}

- (void)swz_setNeedsDisplay {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsDisplay];
}

- (void)swz_setNeedsDisplayInRect:(CGRect)rect {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsDisplayInRect:rect];
}


@end
