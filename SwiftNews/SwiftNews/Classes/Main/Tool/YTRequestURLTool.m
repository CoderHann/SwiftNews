//
//  YTRequestURLTool.m
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTRequestURLTool.h"

@implementation YTRequestURLTool
/** 由tid获取该话题的请求路径*/
+ (NSString *)requestURLWithTname:(NSString *)tname {
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"requestURL.plist" ofType:nil];
    NSDictionary *urlDict = [NSDictionary dictionaryWithContentsOfFile:sourcePath];
    
    return urlDict[tname];
}
+ (NSString *)requestURLWithDocid:(NSString *)docid {
    const NSString *urlPrefix = @"http://c.3g.163.com/nc/article/";
    const NSString *urlSuffix = @"/full.html";
    return [NSString stringWithFormat:@"%@%@%@",urlPrefix,docid,urlSuffix];
}
/** 由setid获取新闻详情的url*/
+ (NSString *)requestURLWithSetID:(NSString *)setID {
    const NSString *urlPrefix = @"http://c.3g.163.com/photo/api/set/";
    const NSString *urlSuffix = @".json";
    NSArray *set = [setID componentsSeparatedByString:@"|"];
    NSString *set2 = [set lastObject];
    NSString *set1 = [set firstObject];
    set1 = [set1 substringFromIndex:(set1.length - 4)];
    return [NSString stringWithFormat:@"%@%@/%@%@",urlPrefix,set1,set2,urlSuffix];
    
}

/** 获取段子url*/
+ (NSString *)requestURLForDuanZi {
    return @"http://c.3g.163.com/recommend/getChanRecomNews?channel=duanzi&size=20";
}

/** 获取话题url*/
+ (NSString *)requestURLForTopics {
    return @"http://c.3g.163.com/nc/topicset/ios/subscribe/manage/listspecial.html";
}

/** 根据视频开始number获取对应的url*/
+ (NSString *)requestURLForHomeVideosWithStartNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/home/%zd-10.html",number];
}

/** 根据视频开始number和类型符号获取分类的url*/
+ (NSString *)requestURLForStyleVideos:(NSString *)style WithStartNumber:(NSUInteger)number {
    return [NSString stringWithFormat:@"http://c.3g.163.com/nc/video/list/%@/y/%zd-10.html",style,number];
}
@end
