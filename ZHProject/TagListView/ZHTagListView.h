//
//  ZHTagListView.h
//  ZHProject
//
//  Created by zh on 2019/5/13.
//  Copyright © 2019 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TagListViewLayoutType) {
    TagListViewLayoutType_default, // 默认平分宽度
    TagListViewLayoutType_selfAdjust // 自适应
};

NS_ASSUME_NONNULL_BEGIN

@interface ZHTagListView : UIView

// tag距离view左(右)边距距
@property (nonatomic, assign) CGFloat leftPadding;
// tag距离view上下边距 defalut 10
@property (nonatomic, assign) CGFloat topPadding;
// tag之间 左右间距 defalut 10
@property (nonatomic, assign) CGFloat lineMargin;
// tag之间 水平间距 default 10
@property (nonatomic, assign) CGFloat rowMargin;
// 标签文字距离标签左边的距离 defalut 10
@property (nonatomic, assign) CGFloat tagLeftPadding;
// 标签文字距离标签上边的距离 defalut 6
@property (nonatomic, assign) CGFloat tagTopPadding;
// 字体大小 defalut 14
@property (nonatomic, assign) NSUInteger fontSize;


// 按钮展示的样式
@property (nonatomic, assign) TagListViewLayoutType layoutType;

// 是否允许拖动排序 ,自适应默认不能允许拖拽排序，否则ui展示及动效上有bug
@property (nonatomic, assign) BOOL enableDrag;

/**
 添加tags

 @param tags tags
 */
- (void)addTags:(NSArray <NSString *> *)tags;

@end

NS_ASSUME_NONNULL_END
