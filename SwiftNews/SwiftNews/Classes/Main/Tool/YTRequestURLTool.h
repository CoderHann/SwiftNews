//
//  YTRequestURLTool.h
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTRequestURLTool : NSObject
/** 由tname获取该话题的请求路径*/
+ (NSString *)requestURLWithTname:(NSString *)tname;
/** 由docid获取新闻详情的url*/
+ (NSString *)requestURLWithDocid:(NSString *)docid;
/** 由setid获取新闻详情的url*/
+ (NSString *)requestURLWithSetID:(NSString *)setID;

/** 获取段子url*/
+ (NSString *)requestURLForDuanZi;
/** 获取话题url*/
+ (NSString *)requestURLForTopics;
/** 根据视频开始number获取home对应的url*/
+ (NSString *)requestURLForHomeVideosWithStartNumber:(NSUInteger)number;
/** 根据视频开始number和类型符号获取分类的url*/
+ (NSString *)requestURLForStyleVideos:(NSString *)style WithStartNumber:(NSUInteger)number;
@end
