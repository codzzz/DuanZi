//
//  HomeViewController.m
//  DuanZi
//
//  Created by sui on 2018/6/12.
//  Copyright © 2018年 sui. All rights reserved.
//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


#import "HomeViewController.h"
#import "IndexViewController.h"
@interface HomeViewController ()<UIScrollViewDelegate>
@property(atomic,strong)UIScrollView *titleScrollView;
@property(atomic,strong)UIScrollView *contentScrollView;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIButton *selectedButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"开心一笑";
    // 1. 初始化标题滚动视图上的按钮
    [self initView];
    [self initButtonsForButtonScrollView];
    
}
- (void)initView{
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.titleScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_titleScrollView];
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-40)];
    self.contentScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_contentScrollView];
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
- (void) initButtonsForButtonScrollView {
    // 初始化子控制器
    [self initChildViewControllers];
    CGFloat buttonWidth = 100;
    CGFloat buttonHeight = 40;
    NSInteger childViewControllerCount = self.childViewControllers.count;
    for (NSInteger i = 0; i < childViewControllerCount; i++) {
        UIViewController *childViewController = self.childViewControllers[i];
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        CGFloat x = i * buttonWidth;
        titleButton.frame = CGRectMake(x, 0, buttonWidth, buttonHeight);
        [titleButton setTitle:childViewController.title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:titleButton];
        
        [self.buttons addObject:titleButton];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(buttonWidth * childViewControllerCount, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.bounces = NO;
    
    self.contentScrollView.contentSize = CGSizeMake(ScreenWidth * childViewControllerCount, 0);
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.delegate = self;
    
    // 禁止额外滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 初始化时默认选中第一个
    [self titleButtonOnClick:self.buttons[0]];
}


- (void)titleButtonOnClick:(UIButton *)button {
    // 1. 选中按钮
    [self selectingButton:button];
    
    // 2. 显示子视图
    [self addViewToContentScrollView:button];
}

- (void)selectingButton:(UIButton *)button {
    [_selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectedButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(1.3, 1.3); // 选中字体变大，按钮变大，字体也跟着变大
    _selectedButton = button;
    
    // 选中按钮时要让选中的按钮居中
    CGFloat offsetX = button.frame.origin.x - ScreenWidth * 0.5;
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - ScreenWidth;
    
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)addViewToContentScrollView:(UIButton *)button {
    NSInteger i = button.tag;
    UIViewController *childViewController = self.childViewControllers[i];
    CGFloat x = i * ScreenWidth;
    
    // 防止添加多次
    if (childViewController.view.subviews != nil) {
        childViewController.view.frame = CGRectMake(x, 0, ScreenWidth, ScreenHeight);
        [self.contentScrollView addSubview:childViewController.view];
    }
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

// 滚动结束时，将对应的视图控制器的视图添加到内容滚动视图中
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger i = self.contentScrollView.contentOffset.x / ScreenWidth;
    [self addViewToContentScrollView:_buttons[i]];
    
    // 内容滚动视图结束后选中对应的标题按钮
    [self selectingButton:_buttons[i]];
}

- (void)initChildViewControllers {
    // 0.头条
    IndexViewController * topViewController = [[IndexViewController alloc] init];
    topViewController.title = @"头条";
    [self addChildViewController:topViewController];
    
    // 1.科技
    IndexViewController * technologyViewController = [[IndexViewController alloc] init];
    technologyViewController.title = @"科技";
    [self addChildViewController:technologyViewController];
    
    // 2.汽车
    IndexViewController * carViewController = [[IndexViewController alloc] init];
    carViewController.title = @"汽车";
    [self addChildViewController:carViewController];
    
    // 3.体育
    IndexViewController * sportsViewController = [[IndexViewController alloc] init];
    sportsViewController.title = @"体育";
    [self addChildViewController:sportsViewController];
    
    // 4.视频
    IndexViewController * videoViewController = [[IndexViewController alloc] init];
    videoViewController.title = @"视频";
    [self addChildViewController:videoViewController];
    
    // 5.图片
    IndexViewController * imageViewController = [[IndexViewController alloc] init];
    imageViewController.title = @"图片";
    [self addChildViewController:imageViewController];
    
    // 6.热点
    IndexViewController * hotViewController = [[IndexViewController alloc] init];
    hotViewController.title = @"热点";
    [self addChildViewController:hotViewController];
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    
    return _buttons;
}
@end
