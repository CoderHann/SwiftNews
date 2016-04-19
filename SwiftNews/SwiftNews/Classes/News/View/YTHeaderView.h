//
//  YTHeaderView.h
//  SwiftNews
//
//  Created by roki on 15/11/11.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YTHeaderViewReuseID @"headerView"

@interface YTHeaderView : UITableViewHeaderFooterView
// 模型
@property(nonatomic,strong) NSArray *items;
/** 根据提供的模型设置headerView*/
+ (instancetype)headerViewWithNewsItems:(NSArray *)items andReuseIdentifier:(NSString *)reuseIdentifier;
@end
