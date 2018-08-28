//
//  MainTabbarViewController.m
//  DuanZi
//
//  Created by sui on 2018/6/11.
//  Copyright © 2018年 sui. All rights reserved.
//

#import "MainTabbarViewController.h"
#import "BaseNavigationViewController.h"
#import "MNPicturesViewController.h"
#import "VideoViewController.h"
#import "OthersViewController.h"
#import "GankViewController.h"
@interface MainTabbarViewController ()

@end

@implementation MainTabbarViewController

+ (void)initialize {
    
    // 设置为不透明
    [[UITabBar appearance] setTranslucent:NO];
    // 设置背景颜色
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    
    // 拿到整个导航控制器的外观
    UITabBarItem * item = [UITabBarItem appearance];
    item.titlePositionAdjustment = UIOffsetMake(0, 1.5);
    
    // 普通状态
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    normalAtts[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.62f green:0.62f blue:0.63f alpha:1.00f];
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    selectAtts[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.42f green:0.33f blue:0.27f alpha:1.00f];
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewControllerWithClassname:[GankViewController description] imagename:@"home" title:@"轻松一刻"];
    [self addChildViewControllerWithClassname:[VideoViewController description] imagename:@"video" title:@"短视频"];
    [self addChildViewControllerWithClassname:[MNPicturesViewController description] imagename:@"girls" title:@"萌妹子"];
    [self addChildViewControllerWithClassname:[OthersViewController description] imagename:@"setting" title:@"设置"];
}
// 添加子控制器
- (void)addChildViewControllerWithClassname:(NSString *)classname
                                  imagename:(NSString *)imagename
                                      title:(NSString *)title {
    
    UIViewController *vc = [[NSClassFromString(classname) alloc] init];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imagename];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:[imagename stringByAppendingString:@"_press"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
