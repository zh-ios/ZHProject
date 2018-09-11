//
//  ZZCycleScrollView.h
//  XGameProject
//
//  Created by zh on 2018/4/27.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZCycleScrollView;
@protocol ZZCycleScrollViewDelegate <NSObject>

/**
 滚动视图内部视图 Class

 @return Class 如： [自定义view class]
 */
- (Class)cycleScrollViewContentViewCls;

/**
 根据data填充视图

 @param cycleView self
 @param view 要填充数据的view
 @param data data
 @param isCenter 是否中心位置
 */
- (void)cycleScrollView:(ZZCycleScrollView *)cycleView fillView:(UIView *)view data:(id)data isCenter:(BOOL)isCenter;

/**
 点击回调

 @param cycleView self
 @param index 点击view的index
 */
- (void)cycleScrollView:(ZZCycleScrollView *)cycleView didSelectedViewAtIndex:(NSInteger)index;

@end

@protocol ZZCycleScrollViewDataSource <NSObject>

/**
 数据源方法

 @return 返回数据源数组
 */
- (NSArray *)cycleScrollViewDataArr;

@end

@interface ZZCycleScrollView : UIView

/**
 注：  两侧漏出的图片的宽度 = (frame.width-imageWidth-2*imageSpacing)/2
 @param imageSpacing 图片间 间距 默认0
 @param imageWidth 图片宽
 */
- (instancetype)initWithFrame:(CGRect)frame
                 imageSpacing:(CGFloat)imageSpacing
                   imageWidth:(CGFloat)imageWidth;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/** 图片高度差 默认0 设置图片高度差出现缩放效果 */
@property(nonatomic, assign) NSUInteger imageHeightIntercept;

/** 图片的圆角半径 */
@property(nonatomic, assign) CGFloat imageRadius;
/** 初始alpha默认1 */
@property(nonatomic, assign) CGFloat initAlpha;

/** 是否显示分页控件,默认YES */
@property(nonatomic, assign) BOOL showPageControl;
/** 当前小圆点颜色 */
@property(nonatomic,strong) UIColor *curPageControlColor;
/** 其余小圆点颜色  */
@property(nonatomic,strong) UIColor *otherPageControlColor;

/** 自动滚动间隔时间,默认5s */
@property(nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否自动滚动,默认NO */
@property(nonatomic,assign) BOOL autoScroll;

@property (nonatomic, weak) id<ZZCycleScrollViewDelegate> delegate;
@property (nonatomic, weak) id<ZZCycleScrollViewDataSource> dataSource;


/**
 设置完属性之后再调用 reloadData
 */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
