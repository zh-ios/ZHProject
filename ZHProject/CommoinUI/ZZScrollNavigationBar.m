//
//  ZZScrollNavigationBar.m
//  XGameProject
//
//  Created by zh on 2018/8/30.
//  Copyright © 2018年 xiaomi. All rights reserved.
//

#import "ZZScrollNavigationBar.h"


@implementation ZZScrollNavigationBarCell 

- (void)setBtnSelected:(BOOL)btnSelected {
    _btnSelected = btnSelected;
    _titleBtn.selected = btnSelected;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_titleBtn setTitle:title forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [_titleBtn setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
}

- (void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    [_titleBtn setTitleColor:self.normalTextColor forState:UIControlStateNormal];
}

- (void)initSubviews {
    _titleBtn = [[UIButton alloc] init];
    _titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleBtn];
    _titleBtn.adjustsImageWhenHighlighted = NO;
    _titleBtn.userInteractionEnabled = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleBtn.frame = self.bounds;
}

@end


@interface ZZScrollNavigationBar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *itemSizeArr;
@property (nonatomic, strong) ZZScrollNavigationBarCell *currentCell;
@property (nonatomic, strong) ZZScrollNavigationBarCell *lastSelectedCell;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat originalW;

@end

@implementation ZZScrollNavigationBar

#define kZZScrollNavigationBarMargin  (12)

static NSString *ZZScrollNavigationBarCellID = @"ZZScrollNavigationBarCellID";

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZZScrollNavigationBarCell class] forCellWithReuseIdentifier:ZZScrollNavigationBarCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.layer.cornerRadius = 2;
        _lineView.layer.masksToBounds = YES;
        _lineView.frame = CGRectMake(0, self.height-4, self.originalW, 4);
    }
    return _lineView;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _titles = titles;
    self.itemSizeArr = @[].mutableCopy;
    for (NSString *title in titles) {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
        [self.itemSizeArr addObject:@(CGSizeMake(titleSize.width + kZZScrollNavigationBarMargin*2, 0))];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    if (self.titles.count == 0) return;
    [self handleCellAlignCenterLogic];
    ZZScrollNavigationBarCell *cell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    if (!cell) return;
    self.currentCell = cell;
    self.currentCell.btnSelected = YES;
    if (self.lastSelectedCell == self.currentCell) return;
    self.lastSelectedCell.btnSelected = NO;
    self.lastSelectedCell = self.currentCell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
        self.selectedIndex = 0;
        self.originalW = 18.0f;
        self.showBottomLineView = YES;
        self.useFlexibleWidth = NO;
        self.selectedTextColor = [UIColor blueColor];
        self.normalTextColor = [UIColor orangeColor];
        self.lineView.backgroundColor = self.selectedTextColor;
    }
    return self;
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    self.lineView.backgroundColor = selectedTextColor;
}

- (void)setShowBottomLineView:(BOOL)showBottomLineView {
    _showBottomLineView = showBottomLineView;
    self.lineView.hidden = !showBottomLineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
//    CGFloat collectionViewW = 0;
//    for (NSNumber *n in self.itemSizeArr) {
//        collectionViewW += [n CGSizeValue].width;
//    }
//    self.collectionView.frame = CGRectMake(0, 0, collectionViewW, self.height);
}

- (void)initSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZScrollNavigationBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZZScrollNavigationBarCellID forIndexPath:indexPath];
    cell.title = self.titles[indexPath.item];
    if (indexPath.item==self.selectedIndex) {
        cell.btnSelected = YES;
        self.currentCell = cell;
        self.lastSelectedCell.btnSelected = NO;
        self.lastSelectedCell = self.currentCell;
        self.lineView.centerX = cell.centerX;
    } else {
        cell.btnSelected = NO;
    }
    cell.selectedTextColor = self.selectedTextColor;
    cell.normalTextColor = self.normalTextColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self.itemSizeArr[indexPath.item] CGSizeValue];
    if (self.useFlexibleWidth) {
        size.width = self.width/self.itemSizeArr.count;
    }
    return CGSizeMake(size.width, self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.item;
    if ([self.delegate respondsToSelector:@selector(scrollViewNavigationBar:selectedIndex:)]) {
        [self.delegate scrollViewNavigationBar:self selectedIndex:self.selectedIndex];
    }
    ZZScrollNavigationBarCell *cell = (ZZScrollNavigationBarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    CGPoint center = [collectionView convertPoint:cell.center toView:self];
    self.lineView.centerX = center.x;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ZZScrollNavigationBarCell *cell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    CGPoint point = [self.collectionView convertPoint:cell.center toView:self];
    self.lineView.center = CGPointMake(point.x, self.lineView.center.y);
}

- (void)targetScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = scrollView.contentOffset.x / scrollView.width;
    [self handleCellAlignCenterLogic];
    ZZScrollNavigationBarCell *cell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    self.currentCell = cell;
    self.currentCell.btnSelected = YES;
    if (self.lastSelectedCell == self.currentCell) return;
    self.lastSelectedCell.btnSelected = NO;
    self.lastSelectedCell = self.currentCell;
}

- (void)handleCellAlignCenterLogic {
    ZZScrollNavigationBarCell *currentCell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0]];
    if (self.collectionView.contentSize.width<self.width) return;
    CGFloat offsetx = currentCell.center.x - self.collectionView.frame.size.width * 0.5;
    CGFloat offsetMax = self.collectionView.contentSize.width - self.collectionView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    } else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.collectionView.contentOffset.y);
    [self.collectionView setContentOffset:offset animated:YES];
}

- (void)targetScollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    CGFloat targetScrollOffsetX = scrollView.contentOffset.x;
    if (targetScrollOffsetX < 0 || targetScrollOffsetX >= (self.titles.count-1)*scrollView.width) return;
    NSInteger index = (NSInteger)(targetScrollOffsetX / scrollView.width);
    if (index == self.titles.count) return;
    
    ZZScrollNavigationBarCell *leftCell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    ZZScrollNavigationBarCell *rightCell = (ZZScrollNavigationBarCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0]];
    // lineView 跟cell 不在一个父视图，所以需要做一次转换 。
    // collection的将其中的子视图的坐标转换到当前view上
    CGPoint lCenter = [self.collectionView convertPoint:leftCell.center toView:self];
    CGPoint rCenter = [self.collectionView convertPoint:rightCell.center toView:self];
    
    CGFloat xx = targetScrollOffsetX / scrollView.width * 100;
    CGFloat rate = (@(xx).intValue % 100) / 100.0;
    CGFloat centertX = lCenter.x + (rCenter.x - lCenter.x) * rate;
    CGFloat zoom = (rCenter.x - lCenter.x) / self.originalW * 1.5;
    
    //底部滑块的响应效果
    self.lineView.center = CGPointMake(centertX, self.lineView.center.y);

    NSArray *lMarginArr = [self transColorBeginColor:self.selectedTextColor andEndColor:self.normalTextColor];
    NSArray *rMarginArr = [self transColorBeginColor:self.normalTextColor andEndColor:self.selectedTextColor];
    UIColor *leftCellColor = [self getColorWithColor:self.selectedTextColor andCoe:rate andMarginArray:lMarginArr];
    UIColor *rightCellColor = [self getColorWithColor:self.normalTextColor andCoe:rate andMarginArray:rMarginArr];

    leftCell.titleBtn.titleLabel.textColor = leftCellColor;
    rightCell.titleBtn.titleLabel.textColor = rightCellColor;
    

    self.lineView.width = self.originalW * (rate > 0.5?(1-rate)*zoom+1:rate*zoom+1);
    // 使用 缩放圆角会被拉伸！！
//  self.lineView.transform = CGAffineTransformMakeScale(rate > 0.5?(1-rate)*zoom+1:rate*zoom+1, 1);
}



- (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor {
    CGFloat r=0,g=0,b=0,a=0;
    [originColor getRed:&r green:&g blue:&b alpha:&a];
    return @[@(r),@(g),@(b)];
}

- (NSArray *)transColorBeginColor:(UIColor *)beginColor andEndColor:(UIColor *)endColor {
    NSArray<NSNumber *> *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    NSArray<NSNumber *> *endColorArr = [self getRGBDictionaryByColor:endColor];

    return @[@([endColorArr[0] doubleValue] - [beginColorArr[0] doubleValue]),
             @([endColorArr[1] doubleValue] - [beginColorArr[1] doubleValue]),
             @([endColorArr[2] doubleValue] - [beginColorArr[2] doubleValue])];
    
}

- (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue]+ coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}


@end
