//
//  YTNewsContentBarTool.h
//  SwiftNews
//
//  Created by roki on 15/11/13.
//  Copyright (c) 2015年 roki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTNewsContentBarTool;

@protocol YTNewsContentBarToolDelegate <NSObject>

@optional
- (void)newsContentBarDidClickedBeforeBtn:(YTNewsContentBarTool *)tool;

- (void)newsContentBarDidClickedShareBtn:(YTNewsContentBarTool *)tool;

@end

@interface YTNewsContentBarTool : UIView

@property(nonatomic,weak) id<YTNewsContentBarToolDelegate> delegate;

@end
