//
//  YTNewsAddTitleView.h
//  SwiftNews
//
//  Created by roki on 15/11/19.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTNewsAddTitleView : UIView
// 已有的标题
@property(nonatomic,strong) NSMutableArray *ownTitle;

// 可以添加的标题
@property(nonatomic,strong) NSMutableArray *enableAddTitle;

@end
