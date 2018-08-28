//
//  VideoViewController.m
//  新闻
//
//  Created by gyh on 15/9/21.
//  Copyright © 2015年 apple. All rights reserved.
//
#import <MJRefresh.h>
#import <MJExtension.h>
#import "VideoViewController.h"
#import "VideoCell.h"
#import "VideoData.h"
#import "VideoDataFrame.h"
#import "DetailViewController.h"
#import "GYHHeadeRefreshController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GYHCircleLoadingView.h"
#import "GYPlayer.h"
#import "BaseEngine.h"

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSMutableArray *             videoArray;
@property (nonatomic , weak) UITableView *                  tableview;
@property (nonatomic , assign)int                           count;
//@property (nonatomic , strong) TabbarButton *               btn;

@property (nonatomic , strong) GYPlayer     *               player;
@property (nonatomic , assign) int                          currtRow;

@property (nonatomic)          CGFloat                      currentOriginY;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = RGBA(239, 239, 244, 1);
    
    [self initUI];
    self.navigationItem.title = @"短视频";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
}

- (void)initUI
{
    UITableView *tableview = [[UITableView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.frame = self.view.frame;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableFooterView = [[UIView alloc]init];
    
    IMP_BLOCK_SELF(VideoViewController);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        block_self.count = 0;
        [block_self initNetWork];
    }];
    header.lastUpdatedTimeLabel.hidden = NO;
    header.stateLabel.hidden = NO;
    self.tableview.mj_header = header;
    [header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [block_self initNetWork];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [VideoCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.videodataframe = self.videoArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoframe = self.videoArray[indexPath.row];
    VideoData *videodata = videoframe.videodata;
    
    //创建播放器
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
    CGFloat originY = videoframe.cellH*indexPath.row+videoframe.coverF.origin.y;
    self.currentOriginY = originY;
    self.player = [[GYPlayer alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_WIDTH * 0.56)];
    self.player.mp4_url = videodata.mp4_url;
    self.player.title = videodata.title;
    self.player.currentOriginY = originY;
    IMP_BLOCK_SELF(VideoViewController);
    self.player.currentRowBlock = ^(){
        [block_self.tableview addSubview:block_self.player];
    };
    [self.tableview addSubview:self.player];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoDataFrame *videoFrame = self.videoArray[indexPath.row];
    return videoFrame.cellH;
}

//判断滚动事件，如何超出播放界面，停止播放
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.player) {
        if (fabs(scrollView.contentOffset.y)+64 > CGRectGetMaxY(self.player.frame)) {
            [self.player removePlayer];
            self.player = nil;
        }
    }
}

#pragma mark - action



- (void)dealloc {
    if (self.player) {
        [self.player removePlayer];
        self.player = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - load data
- (void)initNetWork
{
    IMP_BLOCK_SELF(VideoViewController);
    NSString *getstr = [NSString stringWithFormat:@"http://c.m.163.com/nc/video/home/%d-10.html",self.count];
    
    [[BaseEngine shareEngine] runRequestWithPara:nil path:getstr success:^(id responseObject) {
        
        NSArray *dataarray = [VideoData mj_objectArrayWithKeyValuesArray:responseObject[@"videoList"]];
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (VideoData *videodata in dataarray) {
            VideoDataFrame *videodataFrame = [[VideoDataFrame alloc] init];
            videodataFrame.videodata = videodata;
            [statusFrameArray addObject:videodataFrame];
        }
        
        if (block_self.count == 0) {
            block_self.videoArray = statusFrameArray;
        }else{
            [block_self.videoArray addObjectsFromArray:statusFrameArray];
        }
        
        block_self.count += 10;
        [block_self.tableview reloadData];
        [block_self.tableview.mj_header endRefreshing];
        [block_self.tableview.mj_footer endRefreshing];
        block_self.tableview.mj_footer.hidden = dataarray.count < 10;

    } failure:^(id error) {
        [block_self.tableview.mj_header endRefreshing];
        [block_self.tableview.mj_footer endRefreshing];
    }];
}
#pragma mark - lazy
- (NSMutableArray *)videoArray
{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
@end
