//
//  YTCollectionViewCell.h
//  SwiftNews
//
//  Created by roki on 15/11/6.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YTCellReuseIdentifierID @"newsCell"
@class YTNewsTopicItem;
@class YTCollectionViewCell;
@class YTNewsWebController;
@protocol YTCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionViewCell:(YTCollectionViewCell *)cell showNewsContentView:(YTNewsWebController *)contentVC;

@end
@interface YTCollectionViewCell : UICollectionViewCell
// 话题模型
@property(nonatomic,strong) YTNewsTopicItem *newsTopicItem;
/** 代理，告诉显示新闻内容*/
@property(nonatomic,weak) id<YTCollectionViewCellDelegate> delegate;
// 创建一个cell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;
@end
