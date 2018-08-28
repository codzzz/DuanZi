//
//  GankViewController.m
//  GankMM
//
//  Created by 马宁 on 16/5/9.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "GankViewController.h"
#import "MNGankBaseController.h"

@interface GankViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;

/**
 *  当前选中的title
 */
@property(nonatomic,strong)UILabel *currentSelectedLable;

/**
 *  标签栏底部的红色指示器
 */
@property(nonatomic,weak)UIView *indicatorView;

@end

@implementation GankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    //不自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.contentScrollView.delegate = self;
    
    [self setChildContent];
    
    [self setTitleViews];
    
    //默认显示第一个
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //状态栏设置
    [[MNTopWindowController shareInstance] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)setNavigation
{
    self.navigationItem.title = @"开心一笑";
}

-(void)setTitleViews
{
    //基本变量
    CGFloat count = self.childViewControllers.count;
    CGFloat lableW = MNScreenW / count;
    CGFloat lableY = 0;
    CGFloat lableX = 0;
    CGFloat lableH = 44;
    
    //添加
    for (NSInteger i = 0; i< count; i++) {
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:14];
        [lable setTextColor:GankTabBarGrayColor];
        [lable setHighlightedTextColor:GankMainColor];
        lable.text = [self.childViewControllers[i] title];
        lableX = lableW * i;
        lable.frame = CGRectMake(lableX, lableY, lableW, lableH);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.backgroundColor = [UIColor clearColor];
        //手势
        [lable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)]];
        lable.userInteractionEnabled = YES;
        lable.tag = i;
        [self.titleScrollView addSubview:lable];
        
        //默认第一个按钮
        if(i == 0){
            lable.highlighted = YES;
            _currentSelectedLable = lable;
            lable.font = [UIFont systemFontOfSize:16];
        }
    }
    
    //标签的Indicator
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = GankMainColor;
    indicatorView.height = 2;
    indicatorView.y = lableH - indicatorView.height;
    self.indicatorView = indicatorView;
    //让按钮内部的lable的字计算尺寸
    self.indicatorView.width = 60;
    self.indicatorView.centerX = self.titleScrollView.subviews[0].centerX;
    [self.topView addSubview:self.indicatorView];
    
    //设置ScrollView的ContentSize才能滑动
    self.titleScrollView.contentSize = CGSizeMake(self.childViewControllers.count * lableW, 0);
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width, 0);
    
}

-(void)titleClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    
    //设置偏移量
    CGPoint offset;
    offset.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
    
}

/**
 *  段子 | 趣图 | 动图 | 奇闻异事
 */
-(void)setChildContent
{
    MNGankBaseController *one = [[MNGankBaseController alloc] init];
    one.title = @"段子";
    one.gankDataType = @"341-1";
    [self addChildViewController:one];
    
    MNGankBaseController *two = [[MNGankBaseController alloc] init];
    two.title = @"趣图";
    two.gankDataType = @"341-2";
    [self addChildViewController:two];
    
    MNGankBaseController *three = [[MNGankBaseController alloc] init];
    three.title = @"动图";
    three.gankDataType = @"341-3";
    [self addChildViewController:three];
    
//    MNGankBaseController *four = [[MNGankBaseController alloc] init];
//    four.title = @"奇闻异事";
//    four.gankDataType = @"231-1";
//    [self addChildViewController:four];
    
    
}


#pragma mark - <UIScrollViewDelegate>
/**
 *  人为操作Scroll松开后调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    //控制器的索引
    NSInteger index = scrollView.contentOffset.x / width;
    
    //控制标题
    UILabel *titleLable = self.titleScrollView.subviews[index];
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = titleLable.center.x - width * 0.5;
    if(titleOffset.x <= 0){
        titleOffset.x = 0 ;
    }
    if(titleOffset.x >= self.titleScrollView.contentSize.width - width){
        titleOffset.x = self.titleScrollView.contentSize.width - width ;
    }
    [self.titleScrollView setContentOffset:titleOffset];
    
    //指示器的移动
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.centerX = titleLable.centerX - titleOffset.x;

    }];
    
    //设置标题
    _currentSelectedLable.font = [UIFont systemFontOfSize:14];
    _currentSelectedLable.highlighted = NO;
    _currentSelectedLable = titleLable;
    _currentSelectedLable.highlighted = YES;
    _currentSelectedLable.font = [UIFont systemFontOfSize:16];
    
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    
    //当前位置的控制器已经显示过了
    if([vc isViewLoaded]){
        return;
    }
    
    //设置Frame
    vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    //添加到ScrollView中去
    [scrollView addSubview:vc.view];
    
}


@end
