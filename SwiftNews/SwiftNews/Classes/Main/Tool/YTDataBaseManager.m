//
//  YTDataBaseManager.m
//  SwiftNews
//
//  Created by roki on 15/11/12.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import "YTDataBaseManager.h"
#import "FMDB.h"

@implementation YTDataBaseManager
static FMDatabase *_db;
+ (void)initialize {
    // 1.打开数据库
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"swiftNews.sqlite"];
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    // 2.创建表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_newsTitle (id integer PRIMARY KEY,tid text NOT NULL,url text NOT NULL, newsTitleData blob NOT NULL)"];
}
/** 根据请求url获取存储在数据库中的网络载入数据*/
+ (NSData *)newsTitleWithUrl:(NSString *)url {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_newsTitle WHERE url='%@'",url];
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_newsTitle WHERE url=%@",url];
    
    FMResultSet *set = [_db executeQuery:sql];
    while (set.next) {
        
        return [set dataForColumn:@"newsTitleData"];
        
    }
    return nil;
    
}
/** 根据请求url，网络的数据和tid将数据缓存起来*/
+ (void)saveNewsTitleWithTid:(NSString *)tid url:(NSString *)url andData:(NSData *)data {
    // 插入数据库中
    [_db executeUpdate:@"INSERT INTO t_newsTitle (tid,url,newsTitleData) VALUES (?,?,?)",tid,url,data];
    
//    [_db executeUpdateWithFormat:@"INSERT INTO t_newsTitle (tid,url,newsTitleData) VALUES (%@,%@,%@)",tid,url,data];
}

/** 根据tid，删除所有相关的数据库数据*/
+ (void)deleteNewsTitleWithTid:(NSString *)tid {
    [_db executeUpdateWithFormat:@"DELETE FROM t_newsTitle WHERE tid = %@",tid];
}

/** 根据请求url获取存储在数据库中的网络载入数据*/
+ (NSData *)newsContentTitleWithUrl:(NSString *)url {
    return [self newsTitleWithUrl:url];
}
@end
