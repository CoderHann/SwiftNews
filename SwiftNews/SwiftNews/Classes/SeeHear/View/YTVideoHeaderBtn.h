//
//  YTVideoHeaderBtn.h
//  SwiftNews
//
//  Created by roki on 15/11/18.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTCategoryVideoItem;

@interface YTVideoHeaderBtn : UIButton

/** btn中存储着headerView的标题模型*/
@property(nonatomic,strong) YTCategoryVideoItem *category;
@end
