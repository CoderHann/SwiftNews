//
//  YTNewsItem.h
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewsItem : NSObject
/** 图片的url路径*/
@property(nonatomic,copy) NSString *imgsrc;
/** 新闻描述*/
@property(nonatomic,copy) NSString *digest;
/** 新闻标题*/
@property(nonatomic,copy) NSString *title;
/** 评论数*/
@property(nonatomic,assign) long  replyCount;
/** photosetID,提供照片的id，排除special类新闻*/
@property(nonatomic,copy) NSString *photosetID;
/** imgextra,查看是否是图集*/
@property(nonatomic,copy) NSArray *imgextra;
/** ads,查看是否是headerView*/
@property(nonatomic,copy) NSArray *ads;
/** 判断news是不是special*/
@property(nonatomic,copy) NSString *skipType;
/** 新闻的id*/
@property(nonatomic,copy) NSString *docid;

/** 网页的url*/
@property(nonatomic,copy) NSString *url;

@end
