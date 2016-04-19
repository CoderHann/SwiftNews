//
//  YTNewsContent.h
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewsContent : NSObject
/** 图片*/
@property(nonatomic,copy) NSArray *img;
/** 网页内容*/
@property(nonatomic,copy) NSString *body;
/** 出版时间*/
@property(nonatomic,copy) NSString *ptime;
/** 来源*/
@property(nonatomic,copy) NSString *source;
/** 标题*/
@property(nonatomic,copy) NSString *title;
@end
