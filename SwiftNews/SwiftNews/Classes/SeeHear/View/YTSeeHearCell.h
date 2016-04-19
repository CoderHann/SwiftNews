//
//  YTSeeHearCell.h
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTVideoItem;
@class YTSeeHearCell;

@protocol YTSeeHearCellDelegate <NSObject>

@optional
- (void)seeHearCellDidClickedShareButton:(YTSeeHearCell *)seeHearCell;

@end

@interface YTSeeHearCell : UITableViewCell

@property(nonatomic,weak) id<YTSeeHearCellDelegate> delegate;
/** 视频模型*/
@property(nonatomic,strong) YTVideoItem *item;


+ (instancetype)seeHearCellWithTableView:(UITableView *)tableView;
@end
