//
//  YTDuanZiItemFrame.h
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YTDuanZiDigestFont [UIFont systemFontOfSize:14]


@class YTDuanZiItem;
@interface YTDuanZiItemFrame : NSObject
/** 模型*/
@property(nonatomic,strong) YTDuanZiItem *duanZi;

/** 段子内容*/
@property(nonatomic,assign) CGRect digestF;
/** 段子图片的大小*/
@property(nonatomic,assign) CGRect pixelF;
/** 段子踩个数*/
@property(nonatomic,assign) CGRect downTimesF;
/** 段子赞个数*/
@property(nonatomic,assign) CGRect upTimesF;
/** 分享frame*/
@property(nonatomic,assign) CGRect shareF;
/** cell高度*/
@property(nonatomic,assign) CGFloat cellHeight;

@end
