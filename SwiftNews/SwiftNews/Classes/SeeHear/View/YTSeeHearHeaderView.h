//
//  YTSeeHearHeaderView.h
//  SwiftNews
//
//  Created by roki on 15/11/17.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTVideoHeaderBtn;
@class YTSeeHearHeaderView;

@protocol YTSeeHearHeaderViewDelegate <NSObject>

@optional
- (void)seeHearHeaderView:(YTSeeHearHeaderView *)headerView didClickedCategoryBtn:(YTVideoHeaderBtn *)btn;

@end

@interface YTSeeHearHeaderView : UITableViewHeaderFooterView

@property(nonatomic,weak) id<YTSeeHearHeaderViewDelegate> delegate;
/** 接收分类模型*/
@property(nonatomic,strong) NSArray *categories;
@end
