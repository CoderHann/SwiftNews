//
//  YTNewsContentView.h
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTNewsItem;
@class YTNewsContentBarTool;
@class YTNewsContentView;

@protocol YTNewsContentViewDelegate <NSObject>

@required
- (NSString *)newsContentViewAskForTid:(YTNewsContentView *)contentView;

@end
@interface YTNewsContentView : UIView
/** 新闻模型*/
@property(nonatomic,strong) YTNewsItem *item;
/** 底部工具栏*/
@property(nonatomic,weak) YTNewsContentBarTool *bottomTool;
/** 代理*/
@property(nonatomic,weak) id delegate;
/** 询问tid*/
- (NSString *)askForTid;
// 分享了就会调用这个
- (void)sharedSomeNewsInfo;

@end
