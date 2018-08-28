//
//  MNGankBaseController.m
//  GankMM
//
//  Created by 马宁 on 16/5/10.
//  Copyright © 2016年 马宁. All rights reserved.
//

#import "MNGankBaseController.h"
#import "GankModel.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "MNGankBaseCell.h"
//#import "MNWebViewController.h"
#import "MNGankDao.h"
#import "MNUtils.h"
#import "HappyNetApi.h"
#import "HomeModel.h"
#import "HomeModel2.h"
#import "HomeTextCell.h"
#import "HomeImageCell.h"
#import "HomeWebCell.h"
#import "PhotoBroswerVC.h"
/**
 *  每页加载的大小
 */
static const NSInteger pageSize = 20;
/**
 *  标记,防止网络不好既上啦又下拉，照成数据混乱，以最后一次为主
 */
static NSInteger flag = 0;
/**
 *  cell标识
 */
static NSString * MNGankBaseCellID = @"GankBaseCellID";
static NSString * HomeTextCellID = @"hometextcell";
static NSString * HomeImageCellID = @"homeimagecell";
static NSString * HomeWebCellID = @"homewebcell";
@interface MNGankBaseController ()

/**
 *  数据
 */
@property(nonatomic,strong)NSMutableArray *gankDatas;

/**
 *  第几页数据
 */
@property(nonatomic,assign)NSInteger pageIndex;

@end

@implementation MNGankBaseController

/**
 *  懒加载
 */
-(NSMutableArray *)gankDatas
{
    if(!_gankDatas){
        _gankDatas = [NSMutableArray array];
    }
    return _gankDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化控件
    [self initViews];
    
    //刷新控件
    [self initRefresh];

}

-(void)initViews
{
    //距离顶部的调整
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //不要分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册
    //[self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MNGankBaseCell class]) bundle:nil] forCellReuseIdentifier:MNGankBaseCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeTextCell class]) bundle:nil] forCellReuseIdentifier:HomeTextCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeImageCell class]) bundle:nil] forCellReuseIdentifier:HomeImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeWebCell class]) bundle:nil] forCellReuseIdentifier:HomeWebCellID];
    //设置高度自适应：IOS 8.0 >
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

/**
 *  刷新
 */
-(void)initRefresh
{
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
    
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = NO;
    [self.tableView.mj_footer setHidden:YES];
    
    //获取缓存数据
    NSArray *cacheDatas = [MNGankDao queryCacheWithType:_gankDataType];
    if(cacheDatas!=nil && cacheDatas.count>0){
         _pageIndex = 1;
        _gankDatas = (NSMutableArray *)cacheDatas;
        [self updateCollectState];
        [self.tableView.mj_footer setHidden:NO];
    }else{
        //立马刷新
        [self.tableView.mj_header beginRefreshing];
    }
    
    
 
}


/**
 *  获取数据
 *
 *  @param pageSize  每页大小
 *  @param pageIndex 第几页
 */
-(void)loadNewDatas
{
    //判断有没有网络
    if(![MNUtils isExistenceNetwork]){
        [MyProgressHUD showToast:@"检查你的网络设置"];
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    //网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    _pageIndex = 1;
    flag = 0;
    
    [HappyNetApi getHappyDataWithType:_gankDataType pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {
        if(flag == 1){
            return;
        }
        
        _pageIndex ++;
        
        //字典转模型
        if ([_gankDataType isEqualToString:@"231-1"]) {
            self.gankDatas = [HomeModel2 mj_objectArrayWithKeyValuesArray:dict[@"showapi_res_body"][@"newslist"]];
        }else{
            self.gankDatas = [HomeModel mj_objectArrayWithKeyValuesArray:dict[@"showapi_res_body"][@"contentlist"]];
        }
        [self updateCollectState];
        
        if(self.gankDatas.count > 0){
            [self.tableView.mj_footer setHidden:NO];
        }
        
        //保存最新的20条数据到数据库
        //[MNGankDao saveCache:self.gankDatas type:_gankDataType];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    } failure:^(NSString *text) {
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    }];
}

-(void)loadMoreDatas
{
    //判断有没有网络
    if(![MNUtils isExistenceNetwork]){
        [MyProgressHUD showToast:@"检查你的网络设置"];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    //网络状态
    [MNUtils showNetWorkActivityIndicator:YES];
    
    flag = 1;
    [HappyNetApi getHappyDataWithType:_gankDataType pageSize:pageSize pageIndex:_pageIndex success:^(NSDictionary *dict) {
        if(flag == 0){
            return;
        }
        //页码+1
        _pageIndex ++;
        
        //字典转模型
        NSMutableArray *newDatas = [NSMutableArray array];
        if ([_gankDataType isEqualToString:@"231-1"]) {
            newDatas = [HomeModel2 mj_objectArrayWithKeyValuesArray:dict[@"showapi_res_body"][@"newslist"]];
            //判断新的数据和旧的数据有没有一样的
            HomeModel2 *gankModel;
            HomeModel2 *gankModelNew;
            for (int i=0; i<self.gankDatas.count; i++) {
                gankModel = self.gankDatas[i];
                for (int j= 0; j<newDatas.count; j++) {
                    gankModelNew = newDatas[j];
                    if([gankModelNew._id isEqualToString:gankModel._id]){
                        //移除出集合
                        [newDatas removeObjectAtIndex:j];
                    }
                }
            }
        }else{
            newDatas = [HomeModel mj_objectArrayWithKeyValuesArray:dict[@"showapi_res_body"][@"contentlist"]];
            //判断新的数据和旧的数据有没有一样的
            HomeModel *gankModel;
            HomeModel *gankModelNew;
            for (int i=0; i<self.gankDatas.count; i++) {
                gankModel = self.gankDatas[i];
                for (int j= 0; j<newDatas.count; j++) {
                    gankModelNew = newDatas[j];
                    if([gankModelNew._id isEqualToString:gankModel._id]){
                        //移除出集合
                        [newDatas removeObjectAtIndex:j];
                    }
                }
            }
        }
        
        if(newDatas!=nil && newDatas.count>0){
            //把请求的数组放到当前类别的数组集合中去
            [self.gankDatas addObjectsFromArray:newDatas];
        }
        
        //更新集合的收藏状态
        [self updateCollectState];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
        
    } failure:^(NSString *text) {
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //网络状态
        [MNUtils showNetWorkActivityIndicator:NO];
    }];
    
}

-(void)updateCollectState
{
    for (int i=0; i<self.gankDatas.count; i++) {
        
        GankModel *gankModel = self.gankDatas[i];
        //判断是不是收藏过了
        if([MNGankDao queryIsExist:gankModel._id]){
            gankModel.collect = YES;
        }else{
            gankModel.collect = NO;
        }
        
    }
    
    //刷新表格
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.gankDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取Cell
    //MNGankBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:MNGankBaseCellID];
    if ([_gankDataType isEqualToString:@"341-1"]) {//段子
        HomeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeTextCellID];
        //去掉默认效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //传递数据
        cell.homemodel = self.gankDatas[indexPath.row];
        return cell;
    }else if([_gankDataType isEqualToString:@"341-2"] || [_gankDataType isEqualToString:@"341-3"]){  //趣图 | 动图
        HomeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeImageCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.homemodel = self.gankDatas[indexPath.row];
        return cell;
    }else{ //奇闻异事
        HomeWebCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeWebCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.homemodel = self.gankDatas[indexPath.row];
        NSLog(cell.homemodel.picUrl);
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.gankDataType isEqualToString:@"341-2"] ||[self.gankDataType isEqualToString:@"341-3"]) {
        //避免循环引用
        __weak typeof(self) weakSelf=self;
        [PhotoBroswerVC show:weakSelf type:PhotoBroswerVCTypeModal index:indexPath.row photoModelBlock:^NSArray *{
            
            NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:[self.gankDatas count]];
            for (NSUInteger i = 0; i< self.gankDatas.count; i++) {
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = i + 1;
                HomeModel *model =(HomeModel*)self.gankDatas[i];
                pbModel.image_HD_U = model.img;
                
                [modelsM addObject:pbModel];
            }
            
            return modelsM;
            
            
        }];
    }
    
}

//-------------
-(void)viewDidAppear:(BOOL)animated
{
    //重新刷新一下
    [self updateCollectState];
}

@end
