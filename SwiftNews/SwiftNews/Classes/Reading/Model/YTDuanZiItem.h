//
//  YTDuanZiItem.h
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTDuanZiItem : NSObject
/** 段子内容*/
@property(nonatomic,copy) NSString *digest;
/** 段子图片的大小*/
@property(nonatomic,copy) NSString *pixel;
/** 段子踩个数*/
@property(nonatomic,copy) NSString *downTimes;
/** 段子赞个数*/
@property(nonatomic,copy) NSString *upTimes;
/** 段子图片size*/
@property(nonatomic,assign) CGSize imageSize;
/** 段子图片的url*/
@property(nonatomic,copy) NSString *imgsrc;

@end
