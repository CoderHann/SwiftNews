//
//  YTNewsTitleView.h
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YTNewsTitleBtnW 60
#define YTNewsTitleBtnH 40

@class YTNewsTitleButton;
@class YTNewsTitleView;
@protocol YTNewsTitleViewDelegate <UIScrollViewDelegate>

@optional
- (void)newsTitleView:(YTNewsTitleView *)titleView DidClickedButton:(YTNewsTitleButton *)titleBtn;
/** 当titleView第一次启动时完成加载后通知代理*/
- (void)newsTitleViewDidFinishFirstLoad:(YTNewsTitleView *)titleView;
/** 当titleView更新标题后通知代理*/
- (void)newsTitleViewDidUpdataNewsTitles:(YTNewsTitleView *)titleView;
@end

@interface YTNewsTitleView : UIScrollView

// 代理
@property(nonatomic,weak) id<YTNewsTitleViewDelegate> delegate;
// 点击了第index个按钮
- (void)didclickedNewsButtonAtIndex:(NSUInteger)index;
// 用户的所有标题模型
- (NSArray *)userNewsTitleModels;
// 用户所有的可以添加的标题模型
- (NSArray *)userNewsTitleEnableModels;
/** 更新标题栏*/
- (void)updateNewsTitleWithItems:(NSArray *)items;
/** 更新反馈,当标题更改tableview刷新完数据后回调*/
- (void)updateFeedBack;
/** 更新本地数据*/
- (void)updateDataBaseWithOwnTitle:(NSMutableArray *)own andEnableTitle:(NSMutableArray *)enable;
@end
