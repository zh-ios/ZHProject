//
//  ZZScrollNavigationBar.h
//  XGameProject
//
//  Created by zh on 2018/8/30.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZScrollNavigationBarCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL btnSelected;
@property (nonatomic, strong) UIButton *titleBtn;

@end
@class ZZScrollNavigationBar;
@protocol ZZScrollNavigationBarDelegate <NSObject>

- (void)scrollViewNavigationBar:(ZZScrollNavigationBar *)bar selectedIndex:(NSInteger)index;

@end

@interface ZZScrollNavigationBar : UIView

@property (nonatomic, strong) NSArray<NSString *> *titles;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<ZZScrollNavigationBarDelegate> delegate;

@property (nonatomic, copy) UIColor *normalTextColor;
@property (nonatomic, copy) UIColor *selectedTextColor;

- (void)reloadData;

/**
 滚动条对应的大的scrollView滚动时调用该方法
 */
- (void)targetScollViewDidScroll:(UIScrollView *)scrollView;

- (void)targetScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
