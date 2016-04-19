//
//  YTNewsItemTableViewCell.h
//  SwiftNews
//
//  Created by roki on 15/11/9.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YTTableViewCellHeightDocType 90


@class YTNewsItem;

@interface YTNewsItemTableViewCell : UITableViewCell
// 返回新闻条的cell
+ (instancetype)newsItemCellWithTableView:(UITableView *)tableView;

/** 新闻cell的模型*/
@property(nonatomic,strong) YTNewsItem *newsItem;
@end
