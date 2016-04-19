//
//  YTSeeHearBasicController.h
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTCategoryVideoItem;


@interface YTSeeHearBasicController : UITableViewController

/** 模型*/
@property(nonatomic,strong) YTCategoryVideoItem *category;

/** 存放视频items*/
@property(nonatomic,strong) NSMutableArray *videoItems;
/** 当前获取url，Number*/
@property(nonatomic,assign) NSUInteger startNumber;

@end
