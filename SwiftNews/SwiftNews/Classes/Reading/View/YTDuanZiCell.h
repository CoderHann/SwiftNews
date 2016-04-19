//
//  YTDuanZiCell.h
//  SwiftNews
//
//  Created by roki on 15/11/16.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTDuanZiItemFrame;
@class YTDuanZiCell;

@protocol YTDuanZiCellDelegate <NSObject>

@optional
- (void)duanZiCellDidClickedShareButton:(YTDuanZiCell *)duanZiCell;

@end
@interface YTDuanZiCell : UITableViewCell
@property(nonatomic,weak) id<YTDuanZiCellDelegate> delegate;
/** 包含数据和frame的模型*/
@property(nonatomic,strong) YTDuanZiItemFrame *itemF;

+ (instancetype)duanZiCellWithTableView:(UITableView *)tableView;
@end
