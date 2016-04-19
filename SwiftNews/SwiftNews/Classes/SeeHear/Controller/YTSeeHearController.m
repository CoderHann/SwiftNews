//
//  YTSeeHearController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTSeeHearController.h"
#import "YTRequestURLTool.h"
#import "YTNetRequestTool.h"
#import "YTVideoItem.h"
#import "YTCategoryVideoItem.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "YTSeeHearHeaderView.h"
#import "YTVideoHeaderBtn.h"
@interface YTSeeHearController ()<YTSeeHearHeaderViewDelegate>
// categories
@property(nonatomic,strong) NSArray *categoryItems;

@end

@implementation YTSeeHearController
- (NSArray *)categoryItems {
    if (!_categoryItems) {
        _categoryItems = [[NSArray alloc] init];
    }
    return _categoryItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** headerView设置*/
    [self headerViewSetting];
    
    // 设置导航栏item
    [self setupNaviItem];
    
    

}
/** headerView设置*/
- (void)headerViewSetting {
    YTSeeHearHeaderView *header = [[YTSeeHearHeaderView alloc] initWithReuseIdentifier:@"videoHeader"];
    header.delegate = self;
    header.frame = CGRectMake(0, 0, YTScreenSize.width, 65);
    self.tableView.tableHeaderView = header;

}

- (void)setupNaviItem {
    self.navigationItem.leftBarButtonItem = nil;
    
    // 中间标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.text = @"视频";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.size = [titleLabel.text sizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) withTextFont:titleLabel.font];
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewVideos {
    self.startNumber = 0;
    NSString *url = [YTRequestURLTool requestURLForHomeVideosWithStartNumber:self.startNumber];
    // 发送网络请求
    [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
        self.videoItems = [YTVideoItem objectArrayWithKeyValuesArray:json[@"videoList"]];
        // 给headerView传递模型
        YTSeeHearHeaderView *headerView = (YTSeeHearHeaderView *)self.tableView.tableHeaderView;
        headerView.categories = [YTCategoryVideoItem objectArrayWithKeyValuesArray:json[@"videoSidList"]];
        
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
    
    NSString *url = [YTRequestURLTool requestURLForHomeVideosWithStartNumber:self.startNumber];
    [YTNetRequestTool GET:url withParameters:nil success:^(id json) {
        
        [self.videoItems addObjectsFromArray:[YTVideoItem objectArrayWithKeyValuesArray:json[@"videoList"]]];
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


#pragma mark - headerView Deleagte 
- (void)seeHearHeaderView:(YTSeeHearHeaderView *)headerView didClickedCategoryBtn:(YTVideoHeaderBtn *)btn {
    
    YTSeeHearBasicController *categoryVC = [[YTSeeHearBasicController alloc] init];
    categoryVC.category = btn.category;
    [self.navigationController pushViewController:categoryVC animated:YES];
}

#pragma mark- tableview delegate


@end
