//
//  ZZCycleScrollView.m
//  XGameProject
//
//  Created by zh on 2018/4/27.
//  Copyright © 2018年 xiaomi. All rights reserved.
//
/**
 外层是mainScrollView，里面是图片，
 通过控制图片在父视图中 .x = imageMargin/2
 .width = self.imageWidth
 父视图          .width = self.imageWidth + imageMargin
 两个图片之间的间距就是设置的 imageMargin 值。
 缩放：滚动时改变视图的 height 。
 |--|-------------------
 |  |     图片       |  |
 |  |               |  |
 |--|---------------|--|
 
 */


#import "ZZCycleScrollView.h"

#define kZZMainScrollViewWidth self.mainScrollView.frame.size.width
#define kZZMainScrollViewHeight self.mainScrollView.frame.size.height


@interface ZZCycleScrollView()<UIScrollViewDelegate>

/** 数据源 */
@property(nonatomic,strong) NSArray *data;
/** 页码指示器 */
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *centerView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,assign) NSUInteger currentImageIndex;
@property (nonatomic,assign) CGFloat imgWidth;//图片宽度
@property (nonatomic,assign) CGFloat itemMargnPadding;//间距 2张图片间的间距  默认0
@property (nonatomic,weak) NSTimer *timer;

@end

@implementation ZZCycleScrollView

////  TODO 如果两次返回的数据一样，不用重新滚动到第一个位置

- (instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        self.imgWidth = imageWidth;
        self.itemMargnPadding = imageSpacing;
    }
    return self;
}


-(void)initialization{
    _initAlpha = 1;
    _autoScrollTimeInterval = 5.0;
    _imageHeightIntercept = 0;
    self.otherPageControlColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    self.curPageControlColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    _showPageControl = NO;
    _autoScroll = NO;
    self.data = [NSArray array];
}

- (void)reloadData {
    
    if ([self.dataSource respondsToSelector:@selector(cycleScrollViewDataArr)]) {
        self.data = [self.dataSource cycleScrollViewDataArr];
        if (self.data.count == 0) return;
        [self setupUI];
        self.currentImageIndex = 0;
        self.pageControl.numberOfPages = self.data.count;
        [self setInfoByCurrentImageIndex:self.currentImageIndex];
        
        if (self.data.count != 1) {
            self.mainScrollView.scrollEnabled = YES;
            [self setAutoScroll:self.autoScroll];
        } else {
            [self invalidateTimer];
            self.mainScrollView.scrollEnabled = (kZZMainScrollViewWidth < self.width ? YES : NO);
        }
        
        [_mainScrollView setContentOffset:CGPointMake(kZZMainScrollViewWidth, 0) animated:NO];
        
        [self createPageControl];
    }
}

- (void)setImagesCornerRadius {
    self.leftView.layer.cornerRadius = self.imageRadius;
    self.centerView.layer.cornerRadius = self.imageRadius;
    self.rightView.layer.cornerRadius = self.imageRadius;
    self.leftView.clipsToBounds = YES;
    self.rightView.clipsToBounds = YES;
    self.centerView.clipsToBounds = YES;
}

-(void)setupUI{
    
    [self.leftView removeFromSuperview];
    [self.centerView removeFromSuperview];
    [self.rightView removeFromSuperview];
    [self.mainScrollView removeFromSuperview];
    
    [self addSubview:self.mainScrollView];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewContentViewCls)]) {
        Class cls = [self.delegate cycleScrollViewContentViewCls];
        if ([cls isSubclassOfClass:[UIView class]]) {
            self.leftView = [[cls alloc] init];
            [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapGes)]];
            [self.mainScrollView addSubview:self.leftView];
            
            //图片视图；中间
            self.centerView = [[cls alloc] init];
            [self.centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapGes)]];
            [self.mainScrollView addSubview:self.centerView];
            
            //图片视图；右边
            self.rightView = [[cls alloc] init];
            [self.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapGes)]];
            [self.mainScrollView addSubview:self.rightView];
            
            self.leftView.userInteractionEnabled = YES;
            self.centerView.userInteractionEnabled = YES;
            self.rightView.userInteractionEnabled = YES;
          
            if (self.imageRadius > 0) {
                [self setImagesCornerRadius];
            }
        }
    }
    
    [self updateViewFrameSetting];
}
- (void)setImageHeightIntercept:(NSUInteger)imageHeightIntercept {
    _imageHeightIntercept = imageHeightIntercept;
    [self updateViewFrameSetting];
}

//创建页码指示器
-(void)createPageControl{
    if (_pageControl) [_pageControl removeFromSuperview];
    // 只有0或者一个数据的时候没有pageControl
    if (self.data.count == 0 || self.data.count ==  1) return;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2, kZZMainScrollViewHeight - 37, 200, 30)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.data.count;
    [self addSubview:_pageControl];
    _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    _pageControl.currentPageIndicatorTintColor = self.curPageControlColor;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.hidden = !_showPageControl;
}

#pragma mark - 设置初始尺寸
-(void)updateViewFrameSetting{
    //设置偏移量
    self.mainScrollView.contentSize = CGSizeMake(kZZMainScrollViewWidth * 3, kZZMainScrollViewHeight);
    self.mainScrollView.contentOffset = CGPointMake(kZZMainScrollViewWidth, 0.0);
    
    //图片视图；左边
    self.leftView.frame = CGRectMake(self.itemMargnPadding/2, self.imageHeightIntercept, self.imgWidth, kZZMainScrollViewHeight-self.imageHeightIntercept*2);
    //图片视图；中间
    self.centerView.frame = CGRectMake(kZZMainScrollViewWidth + self.itemMargnPadding/2, 0.0, self.imgWidth, kZZMainScrollViewHeight);
    //图片视图；右边
    self.rightView.frame = CGRectMake(kZZMainScrollViewWidth * 2.0 + self.itemMargnPadding/2, self.imageHeightIntercept, self.imgWidth, kZZMainScrollViewHeight-self.imageHeightIntercept*2);
    
}



- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex {
    if(self.data.count == 0){
        return;
    }

    id dataCenter = self.data[currentImageIndex];

    NSInteger leftIndex = (unsigned long)((_currentImageIndex - 1 + self.data.count) % self.data.count);
    id dataLeft = self.data[leftIndex];

    
    NSInteger rightIndex = (unsigned long)((_currentImageIndex + 1) % self.data.count);
    id dataRight = self.data[rightIndex];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:fillView:data:isCenter:)]) {
        [self.delegate cycleScrollView:self fillView:self.centerView data:dataCenter isCenter:YES];
        [self.delegate cycleScrollView:self fillView:self.leftView data:dataLeft isCenter:NO];
        [self.delegate cycleScrollView:self fillView:self.rightView data:dataRight isCenter:NO];
    }
    _pageControl.currentPage = currentImageIndex;
}


- (void)reloadImage {
    if(self.data.count == 0) {
        return;
    }
    CGPoint contentOffset = [self.mainScrollView contentOffset];
    if (contentOffset.x > kZZMainScrollViewWidth) { //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.data.count;
    } else if (contentOffset.x < kZZMainScrollViewWidth) { //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + self.data.count) % self.data.count;
    }
    
    [self setInfoByCurrentImageIndex:_currentImageIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    
    [self.mainScrollView setContentOffset:CGPointMake(kZZMainScrollViewWidth, 0) animated:NO] ;
    self.pageControl.currentPage = self.currentImageIndex;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self createTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}


#pragma mark -- action
-(void)leftTapGes{}
-(void)rightTapGes{}
-(void)centerTapGes{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectedViewAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectedViewAtIndex:self.currentImageIndex];
    }
}

-(void)createTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll {
    if (0 == self.data.count || 1 == self.data.count) return;
    if(self.mainScrollView.scrollEnabled == NO) return;
    [self.mainScrollView setContentOffset:CGPointMake(kZZMainScrollViewWidth*2, 0.0) animated:YES];
}

#pragma mark -- properties
-(void)setItemMargnPadding:(CGFloat)itemMargnPadding {
    _itemMargnPadding = itemMargnPadding;
    self.mainScrollView.frame = CGRectMake((kZZMainScrollViewWidth - (self.imgWidth + itemMargnPadding))/2, 0, self.imgWidth + itemMargnPadding, kZZMainScrollViewHeight);
    [self updateViewFrameSetting];
}

-(void)setCurPageControlColor:(UIColor *)curPageControlColor {
    _curPageControlColor = curPageControlColor;
    _pageControl.currentPageIndicatorTintColor = curPageControlColor;
}

-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor {
    _otherPageControlColor = otherPageControlColor;
    _pageControl.pageIndicatorTintColor = otherPageControlColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self createTimer];
    }
}

-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}

- (void)setInitAlpha:(CGFloat)initAlpha {
    _initAlpha = initAlpha;
    self.leftView.alpha = self.initAlpha;
    self.centerView.alpha = 1;
    self.rightView.alpha = self.initAlpha;
}

-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.bounces = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (void)dealloc {
    [self invalidateTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    
    if (self.itemMargnPadding > 0) {
        CGFloat currentX = scrollView.contentOffset.x - kZZMainScrollViewWidth;
        CGFloat bl = currentX/kZZMainScrollViewWidth*(1-self.initAlpha);
        CGFloat variableH = currentX/kZZMainScrollViewWidth*self.imageHeightIntercept*2;
        if (currentX > 0) { //左滑
            self.centerView.alpha = 1 - bl;
            self.rightView.alpha = self.initAlpha + bl;
            self.centerView.height = kZZMainScrollViewHeight - variableH;
            self.centerView.top = currentX/kZZMainScrollViewWidth*self.imageHeightIntercept;
            self.rightView.height = kZZMainScrollViewHeight-2*self.imageHeightIntercept+variableH;
            self.rightView.top = self.imageHeightIntercept-currentX/kZZMainScrollViewWidth*self.imageHeightIntercept;
        } else if (currentX < 0){  // 右滑
            self.centerView.alpha = 1 + bl;
            self.leftView.alpha = self.initAlpha - bl;
            self.centerView.height = kZZMainScrollViewHeight + variableH;
            self.centerView.top = -currentX/kZZMainScrollViewWidth*self.imageHeightIntercept;
            self.leftView.height = kZZMainScrollViewHeight-2*self.imageHeightIntercept-variableH;
            self.leftView.top = self.imageHeightIntercept+currentX/kZZMainScrollViewWidth*self.imageHeightIntercept;
        } else {
            self.leftView.alpha = self.initAlpha;
            self.centerView.alpha = 1;
            self.rightView.alpha = self.initAlpha;
            self.leftView.height = kZZMainScrollViewHeight-2*self.imageHeightIntercept;
            self.centerView.height = kZZMainScrollViewHeight;
            self.rightView.height = kZZMainScrollViewHeight-2*self.imageHeightIntercept;
            self.leftView.top = self.imageHeightIntercept;
            self.centerView.top = 0;
            self.rightView.top = self.imageHeightIntercept;
        }
    }
}

@end
