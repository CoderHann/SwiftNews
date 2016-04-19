//
//  YTSeeHearBasicController.m
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "YTSeeHearBasicController.h"
#import "YTSeeHearCell.h"
#import "YTVideoItem.h"
#import "MJRefresh.h"
#import "YTRequestURLTool.h"
#import "YTNetRequestTool.h"
#import "YTCategoryVideoItem.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"


@interface YTSeeHearBasicController ()<YTSeeHearCellDelegate>

@end

@implementation YTSeeHearBasicController

- (NSMutableArray *)videoItems {
    if (!_videoItems) {
        _videoItems = [[NSMutableArray alloc] init];
    }
    return _videoItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加刷新控件
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewVideos)];
    // 下拉刷新，发送视频请求
    [self refreshAndLoadVideoInfo];
    
//    // 添加下拉刷新控件
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVideos)];
    
    /** tableview基本设置*/
    [self tableViewBasicSetting];
    
    // 设置导航栏item
    [self setupNaviItem];
}

/** 设置导航栏item*/
- (void)setupNaviItem {
    UIButton *leftItem = [[UIButton alloc] init];
    [leftItem setImage:[UIImage imageNamed:@"icotab_before_v5"] forState:UIControlStateNormal];
    leftItem.size = leftItem.currentImage.size;
    [leftItem addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    // 中间标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = self.category.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.size = [titleLabel.text sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:titleLabel.font];
    self.navigationItem.titleView = titleLabel;
}

/** tableview基本设置*/
- (void)tableViewBasicSetting {
    self.tableView.backgroundColor = YTRGBColor(222, 222, 222);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.allowsSelection = NO;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshAndLoadVideoInfo {
    // 默认会调用loadNewVideos方法，不要重复调用
    [self.tableView.header beginRefreshing];
//    [self loadNewVideos];
}

- (void)loadNewVideos {
    self.startNumber = 0;
    NSString *url = [YTRequestURLTool requestURLForStyleVideos:self.category.sid WithStartNumber:self.startNumber];
    // 发送网络请求
    [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
        self.videoItems = [YTVideoItem objectArrayWithKeyValuesArray:json[self.category.sid]];
//        NSRange range = NSMakeRange(0, videoItems.count);
//        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.videoItems insertObjects:videoItems atIndexes:set];
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        self.startNumber += 10;
        
    } error:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.header endRefreshing];
        });
        
        [MBProgressHUD showError:@"网络不给力，稍后再试。"];
    }];
}

/** 加载更多的视屏信息*/
- (void)loadMoreVideos {
    
    NSString *url = [YTRequestURLTool requestURLForStyleVideos:self.category.sid WithStartNumber:self.startNumber];
    [YTNetRequestTool GET:url withParameters:nil success:^(id json) {
        
        [self.videoItems addObjectsFromArray:[YTVideoItem objectArrayWithKeyValuesArray:json[self.category.sid]]];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        self.startNumber += 10;
    } error:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.footer endRefreshing];
        });
        
        [MBProgressHUD showError:@"网络不给力，稍后再试。"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -YTSeeHearCellDelegate
- (void)seeHearCellDidClickedShareButton:(YTSeeHearCell *)seeHearCell {
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"564e8a26e0f55aaf2b00000f"
                                      shareText:[NSString stringWithFormat:@"连接:%@ \n%@",seeHearCell.item.mp4_url,seeHearCell.item.title]
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToFacebook,nil]
                                       delegate:self];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.videoItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YTSeeHearCell *cell = [YTSeeHearCell seeHearCellWithTableView:tableView];
    cell.delegate = self;
    cell.item = self.videoItems[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YTVideoItem *item = self.videoItems[indexPath.row];
    JLog(@"didSelectRowAtIndexPath%@",item.mp4_url);
    NSURL *videoURL = [NSURL URLWithString:item.mp4_url];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [self presentViewController:moviePlayer animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 280;
}

@end
