//
//  YTNewsContentView.m
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTNewsContentForHtml.h"
#import "YTNewsContentBarTool.h"
#import "YTRequestURLTool.h"
#import "YTNewsItem.h"
#import "YTNetRequestTool.h"
#import "YTNewsContent.h"
#import "MJExtension.h"
#import "YTNewsContentImage.h"
#import "YTDataBaseManager.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
@interface YTNewsContentForHtml()

/** 网页*/
@property(nonatomic,weak) UIWebView *webView;
@end

@implementation YTNewsContentForHtml

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc] init];
        [self insertSubview:web belowSubview:[self.subviews firstObject]];
//        [self addSubview:web];
        _webView = web;
    }
    return _webView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加webView
        [self setupWebView];
        
    }
    return self;
}
- (void)setupWebView {
    //    self.webView.backgroundColor = YTRGBColor(240, 240, 240);
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:NO];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    self.webView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshingWebHtml)];
    
}

#pragma mark - YTNewsContentBarToolDelegate 代理
- (void)newsContentBarDidClickedShareBtn:(YTNewsContentBarTool *)tool {
    // 发送通知给控制器，分享新闻
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[YTNewsShareKey] = [NSString stringWithFormat:@"%@-%@",self.item.title,self.item.url];
    [YTNotificationCenter postNotificationName:YTNewsShareNotification object:nil userInfo:info];
    [super sharedSomeNewsInfo];
}

// 告诉控件刷新web
- (void)refreshingWebHtml {
    [self loadAndDealFullHtmlWithItem:self.item];
}

- (void)setItem:(YTNewsItem *)item {
     super.item = item;
    
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView.scrollView.header beginRefreshing];
    // 网络请求开始
    [self loadAndDealFullHtmlWithItem:item];
    
}
- (void)loadAndDealFullHtmlWithItem:(YTNewsItem *)item {
    // 网路请求工具
    NSString *url = [YTRequestURLTool requestURLWithDocid:item.docid];
    JLog(@"%@",url);
    // 首先去数据库中查看是否有缓存
    NSData *newsContent = [YTDataBaseManager newsContentTitleWithUrl:url];
    if (newsContent) { // 有缓存
        NSDictionary *json = [NSKeyedUnarchiver unarchiveObjectWithData:newsContent];
        YTNewsContent *newsContent = [YTNewsContent objectWithKeyValues:json[item.docid]];
        [self appendFullHtml:newsContent];
        
    } else {
        [YTNetRequestTool GET:url withParameters:nil success:^(NSDictionary *json) {
            // 存储到数据库
            NSString *tid = [self askForTid];
            if (tid) {
                [YTDataBaseManager saveNewsTitleWithTid:tid url:url andData:[NSKeyedArchiver archivedDataWithRootObject:json]];
            }
            
            // 获取得到的网页数据-》模型
            YTNewsContent *newsContent = [YTNewsContent objectWithKeyValues:json[item.docid]];
            [self appendFullHtml:newsContent];
        } error:^(NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.webView.scrollView.header endRefreshing];
            });
            JLog(@"error:%@",error);
            [MBProgressHUD showError:@"网络不给力，下拉刷新。"];
        }];
    }
}


- (void)appendFullHtml:(YTNewsContent *)newsContent {
    NSString *body = newsContent.body;
    for (NSUInteger i = 0; i < newsContent.img.count; i++) {
        YTNewsContentImage *img = newsContent.img[i];
        // 拼接网页内容
        NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%f\" height=\"%f\">",img.src,img.size.width,img.size.height];
        body = [body stringByReplacingOccurrencesOfString:img.ref withString:imageStr];
    }
    NSString *header = [NSString stringWithFormat:@"<div class = \"title\">%@</div><div class = \"timesource\">%@ %@</div>",newsContent.title,newsContent.ptime,newsContent.source];
    NSString *html = [NSString stringWithFormat:@"%@%@",header,body];
    NSURL *cssURl = [[NSBundle mainBundle] URLForResource:@"html" withExtension:@"css"];
    html = [NSString stringWithFormat:@"%@<link rel=\"stylesheet\" href=\"%@\">",html,cssURl];
    [self.webView loadHTMLString:html baseURL:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView.scrollView.header endRefreshing];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // wenbview
    CGFloat webX = 0;
    CGFloat webY = 20;
    CGFloat webW = YTScreenSize.width;
    CGFloat webH = YTScreenSize.height;
    self.webView.frame = CGRectMake(webX, webY, webW, webH);
    
    
}
@end
