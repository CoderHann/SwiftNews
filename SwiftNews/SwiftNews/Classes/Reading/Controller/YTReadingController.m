//
//  YTReadingController.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTReadingController.h"
#import "MJRefresh.h"
#import "YTRequestURLTool.h"
#import "YTNetRequestTool.h"
#import "YTDuanZiItem.h"
#import "YTDuanZiItemFrame.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "YTDuanZiCell.h"
#import "UMSocial.h"

@interface YTReadingController ()<YTDuanZiCellDelegate>
// 模型数组
@property(nonatomic,strong) NSMutableArray *duanZiItemFs;
@end

@implementation YTReadingController

- (NSMutableArray *)duanZiItemFs {
    if (!_duanZiItemFs) {
        _duanZiItemFs = [[NSMutableArray alloc] init];
    }
    return _duanZiItemFs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self setup];
    
    // 默认进入刷新
    [self loadNewDuanZi];
    [self.tableView.header beginRefreshing];
    
    
}
- (void)setup {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDuanZi)];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDuanZi)];
    
    self.tableView.backgroundColor = YTRGBColor(230, 230, 230);
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"轻松一刻";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor redColor];
    
    titleLabel.size = [titleLabel.text sizeWithMaxSize:CGSizeMake(YTScreenSize.width, CGFLOAT_MAX) withTextFont:titleLabel.font];
    self.navigationItem.titleView = titleLabel;


}
- (void)loadNewDuanZi {
    // 获取url
    NSString *url = [YTRequestURLTool requestURLForDuanZi];
    
    // 发送请求
    [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
        NSMutableArray *array = [YTDuanZiItem objectArrayWithKeyValuesArray:json[@"段子"]];
        for (YTDuanZiItem *item in array) {
            YTDuanZiItemFrame *itemF = [[YTDuanZiItemFrame alloc] init];
            itemF.duanZi = item;
            [self.duanZiItemFs insertObject:itemF atIndex:0];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } error:^(NSError *error) {
        JLog(@"ERROR:%@",error);
        [MBProgressHUD showError:@"网络不给力"];
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreDuanZi {
    // 获取url
    NSString *url = [YTRequestURLTool requestURLForDuanZi];
    
    // 发送请求
    [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
        NSMutableArray *array = [YTDuanZiItem objectArrayWithKeyValuesArray:json[@"段子"]];
        for (YTDuanZiItem *item in array) {
            YTDuanZiItemFrame *itemF = [[YTDuanZiItemFrame alloc] init];
            itemF.duanZi = item;
            [self.duanZiItemFs addObject:itemF];
        }
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    } error:^(NSError *error) {
        [MBProgressHUD showError:@"网络不给力"];
        [self.tableView.footer endRefreshing];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.duanZiItemFs.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTDuanZiCell *cell = [YTDuanZiCell duanZiCellWithTableView:tableView];
    YTDuanZiItemFrame *itemF = self.duanZiItemFs[indexPath.row];
    cell.itemF = itemF;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTDuanZiItemFrame *itemF = self.duanZiItemFs[indexPath.row];
    return itemF.cellHeight + 10;
}

#pragma mark - YTDuanZiCellDelegate 
- (void)duanZiCellDidClickedShareButton:(YTDuanZiCell *)duanZiCell {
    //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"564e8a26e0f55aaf2b00000f"
                                      shareText:[NSString stringWithFormat:@"%@",duanZiCell.itemF.duanZi.digest]
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToFacebook,nil]
                                       delegate:self];
}


@end
