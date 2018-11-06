//
//  ZHTabbarController.m
//  ZHProject
//
//  Created by zh on 2018/10/15.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHTabbarController.h"
#import "ViewController.h"
#import "ZHNavigationController.h"
@interface ZHTabbarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArr;

@end

@implementation ZHTabbarController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}

#pragma mark ————— init TabBar —————
- (void)setUpTabBar{
    UITabBar *tabbar = [[UITabBar alloc] initWithFrame:self.tabBar.frame];
    [self setValue:tabbar forKey:@"tabBar"];
    tabbar.translucent = NO;
    
    // 改变tabbar背景图片、分割线
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
    //添加阴影
    self.tabBar.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowOpacity = 0.6f;
    self.tabBar.layer.shadowRadius = 6.0f;
}

#pragma mark - ——————— init VC ————————
- (void)setUpAllChildViewController {
    
    self.controllersArr = @[].mutableCopy;
    
    ViewController *friendBattleVC = [[ViewController alloc] init];
    [self setupChildViewController:friendBattleVC title:@"朋友" imageName:@"tabbar_message_normal" seleceImageName:@"tabbar_message_selected"];
    
    ViewController *findPlayVC = [[ViewController alloc]init];
    [self setupChildViewController:findPlayVC title:@"游戏" imageName:@"tabbar_findplay_normal" seleceImageName:@"tabbar_findplay_selected"];
    
    ViewController *gameHallVC = [[ViewController alloc] init];
    [self setupChildViewController:gameHallVC title:@"我" imageName:@"tabbar_discovery_normal" seleceImageName:@"tabbar_discovery_selected"];
    
    self.viewControllers = self.controllersArr;
}

- (void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName {
    controller.title = title;
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    
    ZHNavigationController *nav = [[ZHNavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.hidden = YES;
    [self.controllersArr addObject:nav];
}
@end
