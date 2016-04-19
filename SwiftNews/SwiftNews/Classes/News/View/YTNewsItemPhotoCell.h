//
//  YTNewsItemPhotoCell.h
//  SwiftNews
//
//  Created by roki on 15/11/12.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YTTableViewCellHeightPhotoType 118

@class YTNewsItem;

@interface YTNewsItemPhotoCell : UITableViewCell

// 返回新闻条的cell
+ (instancetype)newsItemCellWithTableView:(UITableView *)tableView;

/** 新闻cell的模型*/
@property(nonatomic,strong) YTNewsItem *newsItem;
@end
