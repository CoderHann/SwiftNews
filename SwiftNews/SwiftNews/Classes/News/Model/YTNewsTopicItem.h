//
//  YTNewsTopicItem.h
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTNewsTopicItem : NSObject <NSCoding>
/** 标题名称*/
@property(nonatomic,copy)NSString *tname;
/** 标题ID*/
@property(nonatomic,copy)NSString *tid;

@end
