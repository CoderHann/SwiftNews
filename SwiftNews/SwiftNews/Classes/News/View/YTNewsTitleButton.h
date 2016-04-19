//
//  YTNewTitleButton.h
//  SwiftNews
//
//  Created by roki on 15/11/7.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTNewsTopicItem;

@interface YTNewsTitleButton : UIButton
// 话题模型
@property(nonatomic,strong) YTNewsTopicItem *topic;
@end
