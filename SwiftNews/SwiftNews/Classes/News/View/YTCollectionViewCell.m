//
//  YTCollectionViewCell.m
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTCollectionViewCell.h"
#import "YTView.h"
#import "YTRequestURLTool.h"
#import "YTNewsTopicItem.h"
#import "AFNetworking.h"
#import "YTNewsItem.h"
#import "MJExtension.h"
#import "YTNewsItemTableViewCell.h"
#import "YTNetRequestTool.h"
#import "YTHeaderView.h"
#import "MJRefresh.h"
#import "YTNewsItemPhotoCell.h"
#import "YTDataBaseManager.h"
#import "YTNewsContentForHtml.h"
#import "YTNewsContentForPhoto.h"

#define YTDefaultLoadNumber 20
@interface YTCollectionViewCell()<UITableViewDelegate,UITableViewDataSource,YTNewsContentViewDelegate>
// 存放获得的模型数组
@property(nonatomic,strong) NSMutableArray *newsItems;
// 存放hearderView的模型（YTNewsItem
@property(nonatomic,strong) NSMutableArray *headerItems;
// tableview
@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,assign) NSUInteger loadStartNumber;

/** 新闻内容View*/
@property(nonatomic,weak) YTNewsContentForHtml *htmlView;
/** 新闻内容View*/
@property(nonatomic,weak) YTNewsContentForPhoto *photoView;
@end

@implementation YTCollectionViewCell
@synthesize headerItems = _headerItems;


#pragma mark 懒加载
- (YTNewsContentForHtml *)htmlView {
    if (!_htmlView) {
        YTNewsContentForHtml *content = [[YTNewsContentForHtml alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        content.frame = window.bounds;
        content.x = YTScreenSize.width;
        content.hidden = YES;
        content.delegate = self;
        [window addSubview:content];
        _htmlView = content;
    }
    return _htmlView;
}
- (YTNewsContentForPhoto *)photoView {
    if (!_photoView) {
        YTNewsContentForPhoto *content = [[YTNewsContentForPhoto alloc] init];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        content.frame = window.bounds;
        content.x = YTScreenSize.width;
        content.hidden = YES;
        content.delegate = self;
        [window addSubview:content];
        _photoView = content;
    }
    return _photoView;
}

- (NSMutableArray *)headerItems {
    if (!_headerItems) {
        _headerItems = [[NSMutableArray alloc] init];
    }
    return _headerItems;
}
- (NSMutableArray *)newsItems {
    if (!_newsItems) {
        _newsItems = [[NSMutableArray alloc] init];
    }
    return _newsItems;
}
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.contentInset = UIEdgeInsetsMake(54, 0, 44, 0);
        [self.contentView addSubview:tableView];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = YTRandomColor;
        
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopicDetailsByDrag)];
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopicItems)];
    }
    return self;
}

/** 给headerView传递数据的时候创建headerView*/
- (void)setHeaderItems:(NSMutableArray *)headerItems {
    _headerItems = headerItems;
    // 更新状态和数据
    if (_headerItems.count) {
        YTHeaderView *headView = [YTHeaderView headerViewWithNewsItems:_headerItems andReuseIdentifier:YTHeaderViewReuseID];
        headView.frame = CGRectMake(0, 0, YTScreenSize.width, 170);
        self.tableView.tableHeaderView = headView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
    
}

// 创建一个cell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {
    
    YTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YTCellReuseIdentifierID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[YTCollectionViewCell alloc] init];
        
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.contentView.bounds;
    
    JLog(@"11%@",NSStringFromCGRect(self.frame));
    JLog(@"22%@",NSStringFromCGRect(self.contentView.frame));
    JLog(@"22%@",self.contentView.subviews);
}
/** 传递模型set从写*/
- (void)setNewsTopicItem:(YTNewsTopicItem *)newsTopicItem {
    _newsTopicItem = newsTopicItem;
    // 根据模型属性加载数据
    [self loadNewTopicDetails];

}

/** 加载header数据*/
- (void)loadNewHeaderNewsWithFirstItem:(YTNewsItem *)item {
    NSMutableArray *headerItems = [NSMutableArray array];
    // 是headerView的数据
    if (item.photosetID) {
        [headerItems addObject:item];
    }
    for (NSDictionary *itemDict in item.ads) {
        if ([itemDict[@"tag"] isEqualToString:@"photoset"]) {
            YTNewsItem *newItem = [[YTNewsItem alloc] init];
            newItem.photosetID = itemDict[@"tag"];
            newItem.title = itemDict[@"title"];
            newItem.imgsrc = itemDict[@"imgsrc"];
            [headerItems addObject:newItem];
        }
    }
    // headerItem内容传递给self数值
    self.headerItems = headerItems;
    
}

// 加载话题详情
- (void)loadNewTopicDetails {
    self.loadStartNumber = 0;
    self.tableView.contentOffset = CGPointMake(0, -54);
    
    // 根据话题的tname获得请求url
    NSString *url = [self loadItemURLWithStartNumber:self.loadStartNumber];
    
    // 先看数据库中有没有加载的数据若果有不发送网络请求
    NSData *dataBase = [YTDataBaseManager newsTitleWithUrl:url];
    if (dataBase) {
        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataBase];
        // 刷新tableview
        [self loadTableViewWithJson:dataDict];
        
    } else { //没有缓存的数据，需要进行发请求
        
        // 用自己的http请求工具发请求
        [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
            // 将json数据做成data存放到数据库中
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
            [YTDataBaseManager saveNewsTitleWithTid:self.newsTopicItem.tid url:url andData:data];
            // 刷新tableview
            [self loadTableViewWithJson:json];
        } error:^(NSError *error) {
            JLog(@"error:%@",error);
        }];
        
    }
    
    
}
/** 刷新tableview*/
- (void)loadTableViewWithJson:(NSDictionary *)json {
    
    // 取出原始的数据进行数据采集
    NSMutableArray *originNews = [NSMutableArray array];
    originNews = [YTNewsItem objectArrayWithKeyValuesArray:json[self.newsTopicItem.tid]];
    [self loadNewHeaderNewsWithFirstItem:[originNews firstObject]];
    [originNews removeObjectAtIndex:0];
    self.newsItems = [self dealOriginData:originNews];
    JLog(@"reloadData%zd",self.newsItems.count);
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
    self.loadStartNumber += YTDefaultLoadNumber;
}

/** 下拉刷新时调用这个方法，为了区别自动刷新和手动刷新*/
- (void)loadNewTopicDetailsByDrag {
    self.loadStartNumber = 0;
    NSString *url = [self loadItemURLWithStartNumber:self.loadStartNumber];
    // 用自己的http请求工具发请求
    [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
        // 加载成功了就可以删掉数据库的数据了
        [YTDataBaseManager deleteNewsTitleWithTid:self.newsTopicItem.tid];
        // 将json数据做成data存放到数据库中
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
        [YTDataBaseManager saveNewsTitleWithTid:self.newsTopicItem.tid url:url andData:data];
        // 刷新tableview
        [self loadTableViewWithJson:json];
    } error:^(NSError *error) {
        JLog(@"error:%@",error);
        // 加载本地数据库的数据
        NSData *dataBase = [YTDataBaseManager newsTitleWithUrl:url];
        NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:dataBase];
        // 刷新tableview
        [self loadTableViewWithJson:dataDict];

    }];
}
- (NSMutableArray *)dealOriginData:(NSMutableArray *)originNews {
    // 将含有special的还有live的还有ads的都删掉
    for (NSUInteger i = 0; i < originNews.count; i++) {
        YTNewsItem *item = originNews[i];
//        JLog(@"skipType:%@",item.skipType);
        if ([item.skipType isEqualToString:@"special"] || [item.skipType isEqualToString:@"live"] || item.ads) {
            [originNews removeObjectAtIndex:i];
            i--;
        }
    }
    return originNews;
}
/** 给出加载起始数据返回一个string的url*/
- (NSString *)loadItemURLWithStartNumber:(NSUInteger)startNumber {
    YTNewsTopicItem *newsTopicItem = self.newsTopicItem;
    NSString *urlHead = [YTRequestURLTool requestURLWithTname:newsTopicItem.tname] ;
    NSString *url = [NSString stringWithFormat:@"%@/%@/%zd-20.html",urlHead,newsTopicItem.tid,startNumber];
    return url;
}

- (void)loadMoreTopicItems {
    // 获取请求url
    NSString *url = [self loadItemURLWithStartNumber:self.loadStartNumber];
    // 先看看内存中是否有缓冲
    NSData *dataBase = [YTDataBaseManager newsTitleWithUrl:url];
    if (dataBase) { //有缓存
        NSDictionary *localJson = [NSKeyedUnarchiver unarchiveObjectWithData:dataBase];
        [self refreshTableViewForLoadMore:localJson];
    } else {
        [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
            // 将json数据做成data存放到数据库中
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:json];
            [YTDataBaseManager saveNewsTitleWithTid:self.newsTopicItem.tid url:url andData:data];
            
            // 刷新数据
            [self refreshTableViewForLoadMore:json];
        } error:^(NSError *error) {
            JLog(@"error:%@",error);
        }];
    }
    self.loadStartNumber += YTDefaultLoadNumber;
}
- (void)refreshTableViewForLoadMore:(NSDictionary *)json {
        // 取出原始的数据进行数据采集
    NSMutableArray *originNews = [NSMutableArray array];
    originNews = [YTNewsItem objectArrayWithKeyValuesArray:json[self.newsTopicItem.tid]];
    [self.newsItems addObjectsFromArray:[self dealOriginData:originNews]];
    
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YTNewsItem *newsItem = self.newsItems[indexPath.row];
    // 获得cell
    if (newsItem.photosetID) {
        YTNewsItemPhotoCell *cell = [YTNewsItemPhotoCell newsItemCellWithTableView:tableView];
        cell.newsItem = newsItem;
        return cell;
    } else {
        YTNewsItemTableViewCell *cell = [YTNewsItemTableViewCell newsItemCellWithTableView:tableView];
        // 传递模型
        cell.newsItem = newsItem;
        // return
        return cell;
    }
    

}
#pragma mark - ytnewscontentViewDelegate 代理
- (NSString *)newsContentViewAskForTid:(YTNewsContentView *)contentView {
    return self.newsTopicItem.tid;
}

#pragma mark - tableviewdelegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTNewsItem *newsItem = self.newsItems[indexPath.row];
    return newsItem.photosetID ? YTTableViewCellHeightPhotoType : YTTableViewCellHeightDocType;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JLog(@"选择了%zd",indexPath.row);
    
    YTNewsItem *item = self.newsItems[indexPath.row];
    if (item.photosetID) {
        self.photoView.item = item;
        self.photoView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            self.photoView.x = 0;
        }];
    } else {
        self.htmlView.item = item;
        self.htmlView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.htmlView.x = 0;
        }];
    }
    
}
@end
