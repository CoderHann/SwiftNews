//
//  YTDataBaseManager.h
//  SwiftNews
//
//  Created by roki on 15/11/12.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTDataBaseManager : NSObject
/** 根据tid，删除所有相关的数据库数据*/
+ (void)deleteNewsTitleWithTid:(NSString *)tid;
/** 根据请求url，网络的数据和tid将数据缓存起来*/
+ (void)saveNewsTitleWithTid:(NSString *)tid url:(NSString *)url andData:(NSData *)data;
/** 根据请求url获取存储在数据库中的网络载入数据*/
+ (NSData *)newsTitleWithUrl:(NSString *)url;
/** 根据请求url获取存储在数据库中的网络载入数据*/
+ (NSData *)newsContentTitleWithUrl:(NSString *)url;

@end
