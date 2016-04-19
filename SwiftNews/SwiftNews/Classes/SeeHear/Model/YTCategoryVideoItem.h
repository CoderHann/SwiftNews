//
//  YTCategoryVideoItem.h
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTCategoryVideoItem : NSObject
/** 类别标题*/
@property(nonatomic,copy) NSString *title;
/** 类别id*/
@property(nonatomic,copy) NSString *sid;
/** 类别图片url*/
@property(nonatomic,copy) NSString *imgsrc;

//"sid": "VAP4BFE3U",
//"title": "奇葩",
//"imgsrc": "http://img2.cache.netease.com/m/3g/qipa.png"
@end
