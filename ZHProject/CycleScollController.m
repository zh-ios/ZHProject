//
//  CycleScollController.m
//  ZHProject
//
//  Created by zh on 2018/9/11.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "CycleScollController.h"

#import "ZZCycleScrollView.h"
#import "SettingController.h"

@interface ZZCycleScrollViewContainerView : UIView

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ZZCycleScrollViewContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.imageView.backgroundColor = dict[@"color"];
    self.label.text = dict[@"text"];
}

- (void)initSubviews {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.label.frame = CGRectMake(0, self.height-20, self.width, 20);
}

@end


@interface CycleScollController ()<ZZCycleScrollViewDelegate,ZZCycleScrollViewDataSource,UINavigationControllerDelegate>

@end

@implementation CycleScollController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZZCycleScrollView *scrollView = [[ZZCycleScrollView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, 180) imageSpacing:10 imageWidth:self.view.width-40];
    scrollView.initAlpha = 0.5;
    scrollView.imageRadius = 10.f;
    scrollView.imageHeightIntercept = 15;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.dataSource = self;
    
    
    
    [scrollView reloadData];
}

- (NSArray *)cycleScrollViewDataArr {
    return @[@{@"color":kRandomColor,@"text":@"这是第一个view"},@{@"color":kRandomColor,@"text":@"这是第2个view"},@{@"color":kRandomColor,@"text":@"这是第3个view"},@{@"color":kRandomColor,@"text":@"这是第4个view"},@{@"color":kRandomColor,@"text":@"这是第5个view"}];
}

/**
 滚动视图内部视图 Class
 
 @return Class 如： [自定义view class]
 */
- (Class)cycleScrollViewContentViewCls {
    return [ZZCycleScrollViewContainerView class];
}

/**
 根据data填充视图
 
 @param cycleView self
 @param view 要填充数据的view
 @param data data
 @param isCenter 是否中心位置
 */
- (void)cycleScrollView:(ZZCycleScrollView *)cycleView fillView:(UIView *)view data:(id)data isCenter:(BOOL)isCenter {
    ZZCycleScrollViewContainerView *container = (ZZCycleScrollViewContainerView *)view;
    NSDictionary *dict = data;
    container.dict = dict;
}

/**
 点击回调
 
 @param cycleView self
 @param index 点击view的index
 */
- (void)cycleScrollView:(ZZCycleScrollView *)cycleView didSelectedViewAtIndex:(NSInteger)index {
    NSLog(@"----------->%@",@(index));
    
    [self.navigationController pushViewController:[[SettingController alloc] init] animated:YES];
}


@end
